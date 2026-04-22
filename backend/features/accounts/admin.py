from django.contrib import admin
from .models import Profile


@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    list_display = [
        'student', 'average_rating',
        'completed_sales', 'is_active_seller', 'created_at'
    ]
    readonly_fields = [
        'average_rating', 'total_reviews',
        'items_listed', 'completed_sales', 'created_at'
    ]