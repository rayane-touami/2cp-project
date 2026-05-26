# features/deals/admin.py

from django.contrib import admin
from django.utils.html import format_html
from .models import Deal


@admin.register(Deal)
class DealAdmin(admin.ModelAdmin):
    list_display   = ('id_short', 'buyer_name', 'seller_name', 'listing_title', 'status_badge', 'created_at')
    list_filter    = ('status', 'created_at')
    search_fields  = (
        'buyer__user__email',  'buyer__user__full_name',
        'seller__user__email', 'seller__user__full_name',
        'listing__title'
    )
    ordering       = ('-created_at',)
    readonly_fields = ('buyer', 'seller', 'listing', 'created_at', 'updated_at')
    list_per_page  = 25

    fieldsets = (
        ('Transaction', {
            'fields': ('buyer', 'seller', 'listing', 'status')
        }),
        ('Dates', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',),
        }),
    )

    actions = ['mark_accepted', 'mark_completed', 'mark_cancelled']

    @admin.display(description='ID')
    def id_short(self, obj):
        return format_html(
            '<span style="font-family:monospace; color:#6B7A90; font-size:12px;">#{}</span>',
            str(obj.id)
        )

    @admin.display(description='Acheteur')
    def buyer_name(self, obj):
        return format_html(
            '<span style="font-weight:500;">{}</span>',
            obj.buyer.user.full_name
        )

    @admin.display(description='Vendeur')
    def seller_name(self, obj):
        return format_html(
            '<span style="font-weight:500;">{}</span>',
            obj.seller.user.full_name
        )

    @admin.display(description='Produit')
    def listing_title(self, obj):
        return format_html(
            '<a href="/admin/listings/listing/{}/change/" style="color:#3076E0;">{}</a>',
            obj.listing.id,
            obj.listing.title[:40]
        )

    @admin.display(description='Statut')
    def status_badge(self, obj):
        mapping = {
            'pending':   ('cm-badge-pending',  'En attente'),
            'accepted':  ('cm-badge-spam',     'Accepté'),
            'completed': ('cm-badge-resolved', 'Complété'),
            'cancelled': ('cm-badge-ignored',  'Annulé'),
        }
        cls, label = mapping.get(obj.status, ('cm-badge-other', obj.status))
        return format_html('<span class="cm-badge {}">{}</span>', cls, label)

    @admin.action(description='✅ Accepter les deals sélectionnés')
    def mark_accepted(self, request, queryset):
        n = queryset.filter(status='pending').update(status='accepted')
        self.message_user(request, f"{n} deal(s) accepté(s).")

    @admin.action(description='🏁 Marquer comme Complété')
    def mark_completed(self, request, queryset):
        n = queryset.filter(status='accepted').update(status='completed')
        self.message_user(request, f"{n} deal(s) complété(s).")

    @admin.action(description='❌ Annuler les deals sélectionnés')
    def mark_cancelled(self, request, queryset):
        n = queryset.exclude(status='completed').update(status='cancelled')
        self.message_user(request, f"{n} deal(s) annulé(s).")