from django.urls import path
from .views import UserReviewsView, CreateReviewView, DeleteReviewView

urlpatterns = [
    path('<int:student_id>/', UserReviewsView.as_view(), name='user-reviews'),
    path('create/<int:student_id>/', CreateReviewView.as_view(), name='create-review'),
    path('<int:review_id>/delete/', DeleteReviewView.as_view(), name='delete-review'),
]