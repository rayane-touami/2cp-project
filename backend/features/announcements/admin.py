from django.contrib import admin
from .models import Announcement, Photo

@admin.register(Announcement)
class AnnouncementAdmin(admin.ModelAdmin):
    list_display = ['title', 'student_full_name', 'status', 'created_at']
    list_filter = ['status', 'category']
    search_fields = ['title', 'student_full_name']

@admin.register(Photo)
class PhotoAdmin(admin.ModelAdmin):
    list_display = ['announcement', 'position']