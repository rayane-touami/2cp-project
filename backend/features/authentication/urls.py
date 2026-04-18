from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from . import views

urlpatterns = [
    path('universities/',   views.UniversityListView.as_view()),
    path('register/',       views.RegisterView.as_view()),
    path('login/',          TokenObtainPairView.as_view()),
    path('refresh/',        TokenRefreshView.as_view()),
    path('logout/',         views.LogoutView.as_view()),
    path('me/',             views.UserProfileView.as_view()),
    path('upload-picture/', views.UpdateProfilePictureView.as_view()),
    path('update-profile/', views.UpdateProfileView.as_view()),
    path('verify-email/',   views.VerifyEmailView.as_view()),
    path('resend-code/',    views.ResendVerificationCodeView.as_view()),
    path('forgot-password/', views.ForgotPasswordView.as_view()),
    path('reset-password/', views.ResetPasswordView.as_view()),
]