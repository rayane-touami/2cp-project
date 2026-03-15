# features/announcements/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('categories/', views.CategoryListAPIView.as_view(), name='category-list'),
    path('announcements/', views.AnnouncementListAPIView.as_view(), name='announcement-list'),
    path('announcements/create/', views.AnnouncementCreateAPIView.as_view(), name='announcement-create'),
    path('announcements/<int:pk>/', views.AnnouncementDetailAPIView.as_view(), name='announcement-detail'),
    # Favorites endpoints
    path('favorites/', views.FavoriteListCreateAPIView.as_view(), name='favorite-list'),
    path('favorites/<int:pk>/', views.FavoriteDestroyAPIView.as_view(), name='favorite-detail'),
    path('favorites/check/', views.CheckFavoritesAPIView.as_view(), name='favorite-check'),
]
