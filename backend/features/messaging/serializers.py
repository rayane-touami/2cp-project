from rest_framework import serializers
from features.announcements.models import Announcement
from features.announcements.serializers import AnnouncementListSerializer
from .models import Conversation, Message
from django.contrib.auth import get_user_model

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'full_name']


class MessageSerializer(serializers.ModelSerializer):
    sender = UserSerializer(read_only=True)
    class Meta:
        model = Message
        fields = ['id', 'sender', 'content', 'timestamp', 'is_read']


class ConversationSerializer(serializers.ModelSerializer):
    buyer = UserSerializer(read_only=True)
    seller = UserSerializer(read_only=True)
    announcement = AnnouncementListSerializer(read_only=True)
    announcement_id = serializers.PrimaryKeyRelatedField(
        queryset=Announcement.objects.all(),
        write_only=True,
        source='announcement'
    )
    last_message = serializers.SerializerMethodField()
    last_message_time = serializers.SerializerMethodField()
    unread_count = serializers.SerializerMethodField()

    def get_last_message(self, obj):
        msg = obj.messages.order_by('-timestamp').first()
        return msg.content if msg else ''

    def get_last_message_time(self, obj):
        msg = obj.messages.order_by('-timestamp').first()
        return msg.timestamp.isoformat() if msg else None

    def get_unread_count(self, obj):
        request = self.context.get('request')
        if not request:
            return 0
        return obj.messages.filter(is_read=False).exclude(sender=request.user).count()

    class Meta:
        model = Conversation
        fields = [
            'id', 'buyer', 'seller', 'announcement', 'announcement_id',
            'created_at', 'last_message', 'last_message_time', 'unread_count'
        ]

class StartConversationSerializer(serializers.Serializer):
    seller_id = serializers.CharField()
    announcement_id = serializers.IntegerField()