from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.shortcuts import get_object_or_404

from .models import Deal
from .serializers import DealReadSerializer
from features.listings.models import Listing
from features.authentication.models import Student


class MyDealsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        student = get_object_or_404(Student, user=request.user)
        deals = (
            Deal.objects.filter(buyer=student) |
            Deal.objects.filter(seller=student)
        ).order_by('-created_at')
        serializer = DealReadSerializer(deals, many=True, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)


class CreateDealView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, listing_id):
        listing = get_object_or_404(Listing, id=listing_id)
        student = get_object_or_404(Student, user=request.user)

        if listing.seller == student:
            return Response(
                {'message': 'You cannot buy your own listing.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        if listing.status != Listing.Status.AVAILABLE:
            return Response(
                {'message': 'This listing is no longer available.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        if Deal.objects.filter(
            buyer=student, listing=listing, status=Deal.Status.PENDING
        ).exists():
            return Response(
                {'message': 'You already have a pending deal for this listing.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        deal = Deal.objects.create(
            buyer=student, seller=listing.seller,
            listing=listing, status=Deal.Status.PENDING
        )
        serializer = DealReadSerializer(deal, context={'request': request})
        return Response(
            {'message': 'Deal initiated successfully.', 'data': serializer.data},
            status=status.HTTP_201_CREATED
        )


class CompleteDealView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request, deal_id):
        deal = get_object_or_404(Deal, id=deal_id)
        student = get_object_or_404(Student, user=request.user)
        if deal.seller != student:
            return Response(
                {'message': 'Only the seller can complete a deal.'},
                status=status.HTTP_403_FORBIDDEN
            )
        deal.status = Deal.Status.COMPLETED
        deal.save(update_fields=['status', 'updated_at'])
        deal.listing.status = Listing.Status.SOLD
        deal.listing.save(update_fields=['status'])
        return Response(
            {'message': 'Deal completed successfully.'},
            status=status.HTTP_200_OK
        )


class CancelDealView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request, deal_id):
        deal = get_object_or_404(Deal, id=deal_id)
        student = get_object_or_404(Student, user=request.user)
        if student not in [deal.buyer, deal.seller]:
            return Response(
                {'message': 'You are not part of this deal.'},
                status=status.HTTP_403_FORBIDDEN
            )
        if deal.status == Deal.Status.COMPLETED:
            return Response(
                {'message': 'Cannot cancel a completed deal.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        deal.status = Deal.Status.CANCELLED
        deal.save(update_fields=['status', 'updated_at'])
        return Response(
            {'message': 'Deal cancelled successfully.'},
            status=status.HTTP_200_OK
        )