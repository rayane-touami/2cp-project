from rest_framework import serializers
from .models import Profile


class ProfileReadSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(
        source='student.user.full_name', read_only=True
    )
    email = serializers.SerializerMethodField()
    member_since = serializers.DateTimeField(
        source='student.user.created_at', read_only=True
    )
    university = serializers.SerializerMethodField()
    avatar = serializers.SerializerMethodField()
    is_verified = serializers.SerializerMethodField()
    last_seen_display = serializers.SerializerMethodField()

    # ─── FROM STUDENT MODEL ──────────────────────────────────
    bio = serializers.CharField(
        source='student.description',
        read_only=True,
        allow_null=True
    )
    phone = serializers.CharField(
        source='student.user.phone',
        read_only=True,
        allow_null=True
    )

    class Meta:
        model = Profile
        fields = [
            # Identity
            'id', 'full_name', 'email', 'phone', 'avatar',
            'university', 'is_verified', 'member_since',
            'last_seen_display', 'bio',

            # Trust & Reputation
            'average_rating', 'total_reviews',

            # Seller Stats
            'items_listed', 'completed_sales',
            'response_rate', 'response_time',

            # Settings affecting public view
            'is_active_seller',
        ]

    def get_email(self, obj):
        if obj.show_email:
            return obj.student.user.email
        return None

    def get_university(self, obj):
        if obj.student.university:
            return obj.student.university.name
        return None

    def get_is_verified(self, obj):
        return obj.student.verified

    def get_avatar(self, obj):
        request = self.context.get('request')
        if obj.student.profile_picture and request:
            return request.build_absolute_uri(obj.student.profile_picture.url)
        return None

    def get_last_seen_display(self, obj):
        from django.utils import timezone
        from datetime import timedelta
        if not obj.last_seen:
            return 'Unknown'
        now = timezone.now()
        diff = now - obj.last_seen
        if diff < timedelta(minutes=5):
            return 'Active now'
        elif diff < timedelta(hours=1):
            minutes = int(diff.total_seconds() / 60)
            return f'Last seen {minutes}m ago'
        elif diff < timedelta(days=1):
            hours = int(diff.total_seconds() / 3600)
            return f'Last seen {hours}h ago'
        return f'Last seen {diff.days}d ago'


class ProfileWriteSerializer(serializers.ModelSerializer):
    """
    Allows owner to update profile settings.
    Bio and avatar updates go through Student model directly.
    """
    bio = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = Profile
        fields = [
            'notifications_enabled', 'show_email',
            'is_active_seller', 'response_time', 'bio',
        ]

    def update(self, instance, validated_data):
        # Extract bio and save to Student.description
        bio = validated_data.pop('bio', None)
        if bio is not None:
            instance.student.description = bio
            instance.student.save(update_fields=['description'])

        # Update the rest on Profile model
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        return instance


class ProfileOwnerSerializer(ProfileReadSerializer):
    class Meta(ProfileReadSerializer.Meta):
        fields = ProfileReadSerializer.Meta.fields + [
            'notifications_enabled', 'show_email',
        ]