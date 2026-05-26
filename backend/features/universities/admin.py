# features/universities/admin.py

from django.contrib import admin
from django.utils.html import format_html
from .models import University


@admin.register(University)
class UniversityAdmin(admin.ModelAdmin):
    list_display   = ('logo_preview', 'name', 'location', 'domain', 'student_count', 'announcement_count')
    search_fields  = ('name', 'domain', 'location')
    ordering       = ('name',)
    list_per_page  = 20

    fieldsets = (
        ('Informations', {
            'fields': ('name', 'location', 'domain', 'logo')
        }),
        ('Coordonnées GPS', {
            'fields': ('latitude', 'longitude'),
            'classes': ('collapse',),
        }),
    )

    @admin.display(description='Logo')
    def logo_preview(self, obj):
        if obj.logo:
            return format_html(
                '<img src="{}" height="36" width="36" '
                'style="border-radius:6px; object-fit:cover;"/>',
                obj.logo.url
            )
        initials = obj.name[:2].upper()
        return format_html(
            '<div style="width:36px; height:36px; border-radius:6px; background:#E6F1FB; '
            'color:#3076E0; display:flex; align-items:center; justify-content:center; '
            'font-size:12px; font-weight:700;">{}</div>',
            initials
        )

    @admin.display(description='Étudiants')
    def student_count(self, obj):
        count = obj.student_set.count()
        return format_html('<strong style="color:#3076E0;">{}</strong>', count)

    @admin.display(description='Annonces')
    def announcement_count(self, obj):
        return obj.announcements.count()