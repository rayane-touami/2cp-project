# features/announcements/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('categories/', views.CategoryListAPIView.as_view(), name='category-list'),
    path('announcements/', views.AnnouncementListAPIView.as_view(), name='announcement-list'),
    path('announcements/create/', views.AnnouncementCreateAPIView.as_view(), name='announcement-create'),
    path('announcements/<int:pk>/', views.AnnouncementDetailAPIView.as_view(), name='announcement-detail'),
]
