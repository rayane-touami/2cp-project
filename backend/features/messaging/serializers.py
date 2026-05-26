from rest_framework import serializers
from features.announcements.models import Announcement
from features.announcements.serializers import AnnouncementListSerializer
from .models import Conversation, Message
from django.contrib.auth import get_user_model

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'full_name', 'first_name', 'last_name']


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
    class Meta:
        model = Conversation
        fields = ['id', 'buyer', 'seller', 'announcement', 'announcement_id', 'created_at']


class StartConversationSerializer(serializers.Serializer):
    seller_id = serializers.CharField()
    announcement_id = serializers.IntegerField()