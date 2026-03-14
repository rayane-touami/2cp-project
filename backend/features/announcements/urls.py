from django.urls import path
from . import views

urlpatterns = [
    # category endpoints
    path('categories/', views.CategoryListAPIView.as_view(), name='category-list'),
    
    # announcement endpoints
    path('announcements/', views.AnnouncementListAPIView.as_view(), name='announcement-list'),
    path('announcements/create/', views.AnnouncementCreateAPIView.as_view(), name='announcement-create'),
    path('announcements/<int:pk>/', views.AnnouncementDetailAPIView.as_view(), name='announcement-detail'),
]
