from django.contrib import admin
from .models import Listing


@admin.register(Listing)
class ListingAdmin(admin.ModelAdmin):
    list_display = ['title', 'seller', 'price', 'category', 'condition', 'status', 'created_at']
    list_filter = ['status', 'category', 'condition']
    search_fields = ['title', 'seller__user__email']
    readonly_fields = ['created_at', 'updated_at']