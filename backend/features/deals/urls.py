from django.urls import path
from .views import MyDealsView, CreateDealView, CompleteDealView, CancelDealView

urlpatterns = [
    path('my/', MyDealsView.as_view(), name='my-deals'),
    path('create/<int:listing_id>/', CreateDealView.as_view(), name='create-deal'),
    path('<int:deal_id>/complete/', CompleteDealView.as_view(), name='complete-deal'),
    path('<int:deal_id>/cancel/', CancelDealView.as_view(), name='cancel-deal'),
]