from django.urls import path
from .views import PublicProfileView, MyProfileView, UpdateProfileView

urlpatterns = [
    path('<int:student_id>/', PublicProfileView.as_view(), name='public-profile'),
    path('me/', MyProfileView.as_view(), name='my-profile'),
    path('me/update/', UpdateProfileView.as_view(), name='update-profile'),
]