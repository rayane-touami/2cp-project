from django.urls import path
from . import views

urlpatterns = [
    #categiry
    path('categories/', views.CategoryListAPIView.as_view(), name='category-list'),
    
    # university
    path('universities/', views.UniversityListAPIView.as_view(), name='university-list'),
    
    # ann -read
    path('announcements/', views.AnnouncementListAPIView.as_view(), name='announcement-list'),
    path('announcements/<int:pk>/', views.AnnouncementDetailAPIView.as_view(), name='announcement-detail'),
    
    # ann -write (t7taj auth ofc)
    path('announcements/my/', views.MyAnnouncementsAPIView.as_view(), name='my-announcements'),
    path('announcements/create/', views.AnnouncementCreateAPIView.as_view(), name='announcement-create'),
    path('announcements/<int:pk>/update/', views.AnnouncementUpdateAPIView.as_view(), name='announcement-update'),
    path('announcements/<int:pk>/delete/', views.AnnouncementDeleteAPIView.as_view(), name='announcement-delete'),
    path('announcements/<int:pk>/status/', views.AnnouncementStatusUpdateAPIView.as_view(), name='announcement-status'),
    
    # fav
    path('favorites/', views.FavoriteListCreateAPIView.as_view(), name='favorite-list'),
    path('favorites/<int:pk>/', views.FavoriteDestroyAPIView.as_view(), name='favorite-detail'),
    path('favorites/check/', views.CheckFavoritesAPIView.as_view(), name='favorite-check'),
    
    # rev
    path('announcements/<int:announcement_id>/reviews/', views.ReviewListCreateAPIView.as_view(), name='review-list'),
    path('reviews/<int:pk>/', views.ReviewUpdateDeleteAPIView.as_view(), name='review-detail'),
    
    # comments
    path('announcements/<int:announcement_id>/comments/', views.CommentListCreateAPIView.as_view(), name='comment-list'),
    path('comments/<int:pk>/', views.CommentUpdateDeleteAPIView.as_view(), name='comment-detail'),
]
