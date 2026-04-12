from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from . import views

urlpatterns = [
    path('universities/', views.UniversityListView.as_view()),
    path('register/',     views.RegisterView.as_view()),
    path('login/',        TokenObtainPairView.as_view()),
    path('refresh/',      TokenRefreshView.as_view()),
    path('logout/',       views.LogoutView.as_view()),
    path('me/',           views.UserProfileView.as_view()),
]