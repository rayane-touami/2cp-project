from django.shortcuts import render
from rest_framework import generics, status, pagination
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.parsers import MultiPartParser, FormParser
from django.db.models import Prefetch, Count, F
from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from django.views.decorators.vary import vary_on_headers
from .models import Announcement, Category, Photo
from .serializers import (
    CategorySerializer, 
    AnnouncementListSerializer,
    AnnouncementDetailSerializer,
    AnnouncementCreateSerializer
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
    
    @method_decorator(cache_page(60 * 60))  # Cache for 1 hour
    @method_decorator(vary_on_headers("Authorization",))
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

class AnnouncementListAPIView(generics.ListAPIView):
    serializer_class = AnnouncementListSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    pagination_class = CustomPagination
    
    def get_queryset(self):
        # juste les announcements actifs
        queryset = Announcement.objects.filter(
            status=Announcement.Status.ACTIVE
        ).select_related(
            'category'
        ).prefetch_related(
            Prefetch('photos', queryset=Photo.objects.all()[:1], to_attr='first_photo')
        ).order_by('-created_at')
        
        # filtre by category
        category_id = self.request.query_params.get('category')
        if category_id and category_id.isdigit():
            queryset = queryset.filter(category_id=int(category_id))
        
        # search by title
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.filter(title__icontains=search)
        
        # min price filter
        min_price = self.request.query_params.get('min_price')
        if min_price and min_price.replace('.', '', 1).isdigit():
            queryset = queryset.filter(price__gte=float(min_price))
        
        # max price filter
        max_price = self.request.query_params.get('max_price')
        if max_price and max_price.replace('.', '', 1).isdigit():
            queryset = queryset.filter(price__lte=float(max_price))
        
        return queryset
    
    @method_decorator(cache_page(60 * 5))  # Cache pour 5 minutes
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

class AnnouncementCreateAPIView(generics.CreateAPIView):
    serializer_class = AnnouncementCreateSerializer
    permission_classes = [IsAuthenticated]  # User must be logged in
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
    queryset = Announcement.objects.filter(status=Announcement.Status.ACTIVE)
    serializer_class = AnnouncementDetailSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        Announcement.objects.filter(pk=instance.pk).update(
            views_count=models.F('views_count') + 1
        )
        
        # Refresh to get updated value
        instance.refresh_from_db()
        
        return super().retrieve(request, *args, **kwargs)
