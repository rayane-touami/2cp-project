from rest_framework import serializers
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
    class Meta:
        model = Conversation
        fields = ['id', 'buyer', 'seller', 'listing', 'created_at']

class StartConversationSerializer(serializers.Serializer):
    seller_id = serializers.UUIDField()
    listing = serializers.CharField(max_length=255)