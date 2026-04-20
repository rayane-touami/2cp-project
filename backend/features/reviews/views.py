from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework import status
from django.shortcuts import get_object_or_404

from .models import Review
from .serializers import ReviewReadSerializer, ReviewWriteSerializer
from features.authentication.models import Student


class UserReviewsView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, student_id):
        target = get_object_or_404(Student, id=student_id)
        reviews = Review.objects.filter(target=target).order_by('-created_at')
        serializer = ReviewReadSerializer(reviews, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class CreateReviewView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, student_id):
        target = get_object_or_404(Student, id=student_id)
        reviewer = get_object_or_404(Student, user=request.user)

        if reviewer == target:
            return Response(
                {'message': 'You cannot review yourself.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        if Review.objects.filter(reviewer=reviewer, target=target).exists():
            return Response(
                {'message': 'You have already reviewed this user.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        serializer = ReviewWriteSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(reviewer=reviewer, target=target)
            return Response(
                {'message': 'Review submitted successfully.'},
                status=status.HTTP_201_CREATED
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class DeleteReviewView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, review_id):
        review = get_object_or_404(Review, id=review_id)
        reviewer = get_object_or_404(Student, user=request.user)
        if review.reviewer != reviewer:
            return Response(
                {'message': 'You can only delete your own reviews.'},
                status=status.HTTP_403_FORBIDDEN
            )
        review.delete()
        return Response(
            {'message': 'Review deleted successfully.'},
            status=status.HTTP_204_NO_CONTENT
        )