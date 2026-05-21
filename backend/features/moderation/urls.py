from django.urls import path
from .views import ReportCreateView, ReportListView, ReportDetailView

urlpatterns = [
    # User
    path('reports/',              ReportCreateView.as_view(), name='report-create'),

    # Admin
    path('admin/reports/',        ReportListView.as_view(),   name='report-list'),
    path('admin/reports/<int:pk>/', ReportDetailView.as_view(), name='report-detail'),
]