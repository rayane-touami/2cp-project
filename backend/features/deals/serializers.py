from rest_framework import serializers
from .models import Deal
from features.listings.serializers import ListingReadSerializer


class DealReadSerializer(serializers.ModelSerializer):
    buyer_name = serializers.CharField(source='buyer.user.full_name', read_only=True)
    seller_name = serializers.CharField(source='seller.user.full_name', read_only=True)
    listing = ListingReadSerializer(read_only=True)

    class Meta:
        model = Deal
        fields = [
            'id', 'buyer_name', 'seller_name', 'listing',
            'status', 'created_at', 'updated_at',
        ]