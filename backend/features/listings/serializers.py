from rest_framework import serializers
from .models import Listing


class ListingReadSerializer(serializers.ModelSerializer):
    seller_name = serializers.CharField(
        source='seller.user.full_name', read_only=True
    )
    seller_id = serializers.UUIDField(source='seller.id', read_only=True)  # ← add this
    seller_avatar = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()

    class Meta:
        model = Listing
        fields = [
            'id', 'seller_id','seller_name', 'title', 'description',
            'price', 'currency', 'category', 'condition',
            'status', 'image', 'created_at', 'updated_at',
        ]

    def get_image(self, obj):
        request = self.context.get('request')
        if obj.image and request:
            return request.build_absolute_uri(obj.image.url)
        return None
    def get_seller_avatar(self, obj):                           # ← optional but useful
        request = self.context.get('request')
        try:
            pic = obj.seller.profile_picture
            if pic and request:
                return request.build_absolute_uri(pic.url)
        except Exception:
            return None
        return None

class ListingWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Listing
        fields = [
            'title', 'description', 'price', 'currency',
            'category', 'condition', 'image',
        ]

    def validate_price(self, value):
        if value <= 0:
            raise serializers.ValidationError('Price must be greater than 0.')
        return value

    def validate_title(self, value):
        if not value.strip():
            raise serializers.ValidationError('Title cannot be empty.')
        return value