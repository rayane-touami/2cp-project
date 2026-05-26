# features/reviews/admin.py

from django.contrib import admin
from django.utils.html import format_html
from .models import Review


@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display   = ('reviewer_name', 'arrow', 'target_name', 'rating_stars', 'comment_preview', 'created_at')
    list_filter    = ('score',)
    search_fields  = ('reviewer__user__email', 'reviewer__user__full_name',
                      'target__user__email',   'target__user__full_name', 'comment')
    ordering       = ('-created_at',)
    readonly_fields = ('reviewer', 'target', 'created_at')

    @admin.display(description='Évaluateur')
    def reviewer_name(self, obj):
        return format_html(
            '<span style="font-weight:500;">{}</span>',
            obj.reviewer.user.full_name
        )

    @admin.display(description='')
    def arrow(self, obj):
        return format_html('<span style="color:#6B7A90;">→</span>')

    @admin.display(description='Évalué')
    def target_name(self, obj):
        return format_html(
            '<span style="font-weight:500;">{}</span>',
            obj.target.user.full_name
        )

    @admin.display(description='Note')
    def rating_stars(self, obj):
        filled = '★' * obj.score
        empty  = '☆' * (5 - obj.score)
        color  = '#F59E0B' if obj.score >= 3 else '#EF4444'
        return format_html(
            '<span style="color:{}; font-size:15px; letter-spacing:1px;">{}</span>'
            '<span style="color:#D1D5DB; font-size:15px;">{}</span>',
            color, filled, empty
        )

    @admin.display(description='Commentaire')
    def comment_preview(self, obj):
        return obj.comment[:80] + '…' if len(obj.comment) > 80 else obj.comment or '—'