from django.shortcuts import render
from rest_framework import generics, status, pagination
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.parsers import MultiPartParser, FormParser
from django.db.models import Prefetch, Count, F, Q
from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from django.views.decorators.vary import vary_on_headers
from .models import Announcement, Category, Photo, Favorite, University, Review, Comment
from .serializers import (
    CategorySerializer, 
    AnnouncementListSerializer,
    AnnouncementDetailSerializer,
    AnnouncementCreateSerializer,
    FavoriteSerializer,
    UniversitySerializer,  
    ReviewSerializer,      
    CommentSerializer
)

class CustomPagination(pagination.PageNumberPagination):
    page_size = 20
    page_size_query_param = 'page_size'
    max_page_size = 100
    
    def get_paginated_response(self, data):
        return Response({
            'results': data,
            'count': self.page.paginator.count,
            'next': self.get_next_link(),
            'previous': self.get_previous_link()
        })

class CategoryListAPIView(generics.ListAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    @method_decorator(cache_page(60 * 60))
    @method_decorator(vary_on_headers("Authorization",))
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

class AnnouncementListAPIView(generics.ListAPIView):
    serializer_class = AnnouncementListSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    pagination_class = CustomPagination
    
    def get_queryset(self):
        queryset = Announcement.objects.filter(
            status=Announcement.Status.ACTIVE
        ).select_related(
            'category',
            'university'
        ).prefetch_related(
            Prefetch('photos', queryset=Photo.objects.order_by('position'), to_attr='prefetched_photos')
        ).order_by('-created_at')
        
        category_id = self.request.query_params.get('category')
        if category_id and category_id.isdigit():
            queryset = queryset.filter(category_id=int(category_id))

        university_id = self.request.query_params.get('university')
        if university_id and university_id.isdigit():
            queryset = queryset.filter(university_id=int(university_id))    
        
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.filter(title__icontains=search)
        
        min_price = self.request.query_params.get('min_price')
        if min_price and min_price.replace('.', '', 1).isdigit():
            queryset = queryset.filter(price__gte=float(min_price))
        
        max_price = self.request.query_params.get('max_price')
        if max_price and max_price.replace('.', '', 1).isdigit():
            queryset = queryset.filter(price__lte=float(max_price))
        
        return queryset
    
    @method_decorator(cache_page(60 * 5))
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

class AnnouncementCreateAPIView(generics.CreateAPIView):
    serializer_class = AnnouncementCreateSerializer
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data, context={'request': request})
        
        if serializer.is_valid():
            self.perform_create(serializer)
            
            announcement = serializer.instance
            photos_data = []
            
            for photo in announcement.photos.all().order_by('position'):
                photos_data.append({
                    'url': photo.image.url
                })
            
            response_data = {
                'id': announcement.id,
                'title': announcement.title,
                'price': float(announcement.price),
                'photos': photos_data,
                'created_at': announcement.created_at.isoformat()
            }
            
            return Response(response_data, status=status.HTTP_201_CREATED)
        else:
            return Response(
                {'errors': serializer.errors}, 
                status=status.HTTP_400_BAD_REQUEST
            )
    
    def perform_create(self, serializer):
        serializer.save()

class AnnouncementDetailAPIView(generics.RetrieveAPIView):
    serializer_class = AnnouncementDetailSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        user_id = getattr(self.request, 'user_id', None)
        if user_id:
            return Announcement.objects.filter(
                Q(status=Announcement.Status.ACTIVE) | Q(student_id=user_id)
            )
        return Announcement.objects.filter(status=Announcement.Status.ACTIVE)
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        Announcement.objects.filter(pk=instance.pk).update(
            views_count=F('views_count') + 1
        )
        instance.refresh_from_db()
        return super().retrieve(request, *args, **kwargs)

class FavoriteListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = FavoriteSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Favorite.objects.filter(user_id=self.request.user_id).select_related('announcement__category')
    
    def perform_create(self, serializer):
        serializer.save(user_id=self.request.user_id)

class FavoriteDestroyAPIView(generics.DestroyAPIView):
    """remove from favorites"""
    permission_classes = [IsAuthenticated]
    lookup_field = 'pk'
    
    def get_queryset(self):
        return Favorite.objects.filter(user_id=self.request.user_id)

class CheckFavoritesAPIView(generics.GenericAPIView):
    """Check which announcements are favorited"""
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        announcement_ids = request.data.get('announcement_ids', [])
        if not announcement_ids:
            return Response({'favorited_ids': []})
        
        favorites = Favorite.objects.filter(
            user_id=request.user_id,
            announcement_id__in=announcement_ids
        ).values_list('announcement_id', flat=True)
        
        return Response({
            'favorited_ids': list(favorites)
        })

class UniversityListAPIView(generics.ListAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    @method_decorator(cache_page(60 * 60 * 24))
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

class MyAnnouncementsAPIView(generics.ListAPIView):
    serializer_class = AnnouncementListSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Announcement.objects.filter(
            student_id=self.request.user_id
        ).select_related(
            'category', 'university'
        ).prefetch_related(
            Prefetch('photos', queryset=Photo.objects.order_by('position'), to_attr='prefetched_photos')
        ).order_by('-created_at')

class AnnouncementUpdateAPIView(generics.UpdateAPIView):
    queryset = Announcement.objects.all()
    serializer_class = AnnouncementCreateSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Announcement.objects.filter(student_id=self.request.user_id)

class AnnouncementDeleteAPIView(generics.DestroyAPIView):
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Announcement.objects.filter(student_id=self.request.user_id)

class AnnouncementStatusUpdateAPIView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Announcement.objects.filter(student_id=self.request.user_id)
    
    def patch(self, request, *args, **kwargs):
        instance = self.get_object()
        status_value = request.data.get('status')
        if status_value in ['active', 'sold', 'expired']:
            instance.status = status_value
            instance.save()
            return Response({'status': status_value})
        return Response({'error': 'Invalid status'}, status=400)

class ReviewListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = ReviewSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def get_queryset(self):
        return Review.objects.filter(announcement_id=self.kwargs['announcement_id'])
    
    def perform_create(self, serializer):
        serializer.save(
            user_id=self.request.user_id,
            announcement_id=self.kwargs['announcement_id']
        )

class ReviewUpdateDeleteAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Review.objects.all()
    serializer_class = ReviewSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Review.objects.filter(user_id=self.request.user_id)

class CommentListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = CommentSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def get_queryset(self):
        return Comment.objects.filter(
            announcement_id=self.kwargs['announcement_id'],
            parent=None
        ).prefetch_related('replies')
    
    def perform_create(self, serializer):
        serializer.save(
            user_id=self.request.user_id,
            announcement_id=self.kwargs['announcement_id']
        )

class CommentUpdateDeleteAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Comment.objects.filter(user_id=self.request.user_id)
