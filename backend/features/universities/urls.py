from django.urls import path
from .views import UniversityListView

urlpatterns = [
    path('universities/', UniversityListView.as_view(), name='university-list'),
]