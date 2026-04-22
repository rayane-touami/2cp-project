from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework import status
from django.shortcuts import get_object_or_404
from django.utils import timezone

from .models import Profile
from .serializers import ProfileReadSerializer, ProfileWriteSerializer, ProfileOwnerSerializer
from features.authentication.models import Student


class PublicProfileView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, student_id):
        profile = get_object_or_404(Profile, student__id=student_id)
        serializer = ProfileReadSerializer(profile, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)


class MyProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        profile = get_object_or_404(Profile, student__user=request.user)
        profile.last_seen = timezone.now()
        profile.save(update_fields=['last_seen'])
        serializer = ProfileOwnerSerializer(profile, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)


class UpdateProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request):
        profile = get_object_or_404(Profile, student__user=request.user)
        serializer = ProfileWriteSerializer(
            profile, data=request.data, partial=True
        )
        if serializer.is_valid():
            serializer.save()
            return Response(
                {'message': 'Profile updated successfully.', 'data': serializer.data},
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)