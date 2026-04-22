from django.contrib import admin
from .models import Deal


@admin.register(Deal)
class DealAdmin(admin.ModelAdmin):
    list_display = ['buyer', 'seller', 'listing', 'status', 'created_at']
    list_filter = ['status']
    search_fields = ['buyer__user__email', 'seller__user__email']
    readonly_fields = ['created_at', 'updated_at']