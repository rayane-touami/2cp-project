from django.urls import path
from . import views

urlpatterns = [
    path('notifications/',                  views.NotificationListAPIView.as_view(),        name='notification-list'),
    path('notifications/unread-count/',     views.NotificationUnreadCountAPIView.as_view(), name='notification-unread-count'),
    path('notifications/read-all/',         views.NotificationMarkAllReadAPIView.as_view(), name='notification-read-all'),
    path('notifications/<int:pk>/read/',    views.NotificationMarkReadAPIView.as_view(),    name='notification-read'),
]