# features/accounts/admin.py

from django.contrib import admin
from django.utils.html import format_html
from .models import Profile


@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    list_display   = (
        'student_name', 'university_name', 'rating_display',
        'total_reviews', 'items_listed', 'completed_sales',
        'is_active_seller_badge', 'last_seen'
    )
    list_filter    = ('is_active_seller', 'notifications_enabled', 'show_email')
    search_fields  = ('student__user__email', 'student__user__full_name')
    ordering       = ('-created_at',)
    readonly_fields = (
        'average_rating', 'total_reviews', 'items_listed',
        'completed_sales', 'response_rate', 'last_seen', 'created_at'
    )
    list_per_page  = 25

    fieldsets = (
        ('Étudiant', {
            'fields': ('student',)
        }),
        ('Réputation', {
            'fields': ('average_rating', 'total_reviews'),
            'classes': ('collapse',),
        }),
        ('Statistiques vendeur', {
            'fields': ('items_listed', 'completed_sales', 'response_rate', 'response_time'),
            'classes': ('collapse',),
        }),
        ('Paramètres', {
            'fields': ('is_active_seller', 'notifications_enabled', 'show_email'),
        }),
        ('Activité', {
            'fields': ('last_seen', 'created_at'),
            'classes': ('collapse',),
        }),
    )

    @admin.display(description='Étudiant')
    def student_name(self, obj):
        return format_html(
            '<span style="font-weight:500;">{}</span>',
            obj.student.user.full_name
        )

    @admin.display(description='Université')
    def university_name(self, obj):
        uni = obj.student.university
        return uni.name if uni else format_html('<span style="color:#6B7A90;">—</span>')

    @admin.display(description='Note moyenne')
    def rating_display(self, obj):
        score    = float(obj.average_rating)
        filled   = '★' * int(score)
        empty    = '☆' * (5 - int(score))
        color    = '#F59E0B' if score >= 3 else '#EF4444'
        return format_html(
            '<span style="color:{}; font-size:14px;">{}</span>'
            '<span style="color:#D1D5DB; font-size:14px;">{}</span> '
            '<small style="color:#6B7A90;">({})</small>',
            color, filled, empty, obj.average_rating
        )

    @admin.display(description='Vendeur actif')
    def is_active_seller_badge(self, obj):
        if obj.is_active_seller:
            return format_html('<span class="cm-badge cm-badge-resolved">Actif</span>')
        return format_html('<span class="cm-badge cm-badge-ignored">Inactif</span>')