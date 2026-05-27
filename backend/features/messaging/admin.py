from django.contrib import admin
from .models import Conversation, Message

@admin.register(Conversation)
class ConversationAdmin(admin.ModelAdmin):
    list_display = [
        'id', 'buyer', 'seller', 'announcement',
        'created_at', 'is_deleted_by_buyer', 'is_deleted_by_seller'
    ]
    list_filter = ['is_deleted_by_buyer', 'is_deleted_by_seller']
    search_fields = ['buyer__email', 'seller__email']
    readonly_fields = ['buyer', 'seller', 'announcement', 'created_at']


@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    list_display = ['id', 'conversation', 'sender', 'content', 'timestamp', 'is_read']
    search_fields = ['sender__email', 'content']
    readonly_fields = ['conversation', 'sender', 'content', 'timestamp']