from django.urls import path
from .user_views import UpdateUserView, LogoutView

urlpatterns = [
    path('me/', UpdateUserView.as_view(), name='update-user'),
    path('logout/', LogoutView.as_view(), name='logout'),
]