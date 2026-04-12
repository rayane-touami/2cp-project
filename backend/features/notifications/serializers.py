from rest_framework import serializers
from .models import Notification


class NotificationSerializer(serializers.ModelSerializer):

    class Meta:
        model = Notification
        fields = [
            'id',
            'type',
            'content',
            'is_read',
            'created_at',
            # deep-link targets
            'announcement_id',
            'conversation_id',
            'comment_id',
            # message inline preview :3
            'message_preview',
            'message_image_url',
            # who triggered it
            'actor_id',
            'actor_full_name',
        ]
        read_only_fields = fields # notifications are read-only from the client side, the seller don't get (this one read ur nots)