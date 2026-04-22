from django.contrib import admin
from .models import Review


@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ['reviewer', 'target', 'score', 'created_at']
    search_fields = ['reviewer__user__email', 'target__user__email']
    readonly_fields = ['created_at']