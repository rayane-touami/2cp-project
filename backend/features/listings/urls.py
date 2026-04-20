from django.urls import path
from .views import (
    ListingListView, ListingDetailView, ListingCreateView,
    ListingUpdateView, ListingDeleteView, ListingMarkSoldView,
    MyListingsView, SellerListingsView,
)

urlpatterns = [
    path('', ListingListView.as_view(), name='listing-list'),
    path('<int:listing_id>/', ListingDetailView.as_view(), name='listing-detail'),
    path('create/', ListingCreateView.as_view(), name='listing-create'),
    path('<int:listing_id>/update/', ListingUpdateView.as_view(), name='listing-update'),
    path('<int:listing_id>/delete/', ListingDeleteView.as_view(), name='listing-delete'),
    path('<int:listing_id>/mark-sold/', ListingMarkSoldView.as_view(), name='listing-mark-sold'),
    path('my/', MyListingsView.as_view(), name='my-listings'),
    path('seller/<int:student_id>/', SellerListingsView.as_view(), name='seller-listings'),
]