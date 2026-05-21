from django.urls import path
from .views import UniversityListView

urlpatterns = [
    path('', UniversityListView.as_view(), name='university-list'),
]