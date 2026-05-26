# features/listings/admin.py

from django.contrib import admin
from django.utils.html import format_html
from .models import Listing


@admin.register(Listing)
class ListingAdmin(admin.ModelAdmin):
    list_display   = (
        'image_preview', 'title', 'seller_name',
        'price_display', 'category_badge', 'condition_badge', 'status_badge', 'created_at'
    )
    list_filter    = ('status', 'category', 'condition', 'currency')
    search_fields  = ('title', 'description', 'seller__user__email', 'seller__user__full_name')
    ordering       = ('-created_at',)
    list_per_page  = 25
    readonly_fields = ('created_at', 'updated_at', 'image_preview_large')

    fieldsets = (
        ('Produit', {
            'fields': ('title', 'description', 'price', 'currency', 'category', 'condition', 'image', 'image_preview_large')
        }),
        ('Vendeur', {
            'fields': ('seller',)
        }),
        ('Statut', {
            'fields': ('status',)
        }),
        ('Dates', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',),
        }),
    )

    actions = ['mark_available', 'mark_sold']

    @admin.display(description='')
    def image_preview(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" height="40" width="40" '
                'style="border-radius:6px; object-fit:cover;"/>',
                obj.image.url
            )
        return format_html(
            '<div style="width:40px; height:40px; border-radius:6px; background:#F4F7FC; '
            'display:flex; align-items:center; justify-content:center;">'
            '<i class="fas fa-image" style="color:#6B7A90;"></i></div>'
        )

    @admin.display(description='Aperçu')
    def image_preview_large(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" height="120" style="border-radius:8px; object-fit:cover;"/>',
                obj.image.url
            )
        return '—'

    @admin.display(description='Vendeur')
    def seller_name(self, obj):
        return format_html(
            '<span style="font-weight:500;">{}</span>',
            obj.seller.user.full_name
        )

    @admin.display(description='Prix')
    def price_display(self, obj):
        return format_html(
            '<strong style="color:#1A2535;">{} {}</strong>',
            obj.price, obj.currency
        )

    @admin.display(description='Catégorie')
    def category_badge(self, obj):
        return format_html(
            '<span class="cm-badge cm-badge-spam">{}</span>',
            obj.get_category_display()
        )

    @admin.display(description='État')
    def condition_badge(self, obj):
        if obj.condition == 'new':
            return format_html('<span class="cm-badge cm-badge-resolved">Neuf</span>')
        return format_html('<span class="cm-badge cm-badge-pending">Usagé</span>')

    @admin.display(description='Statut')
    def status_badge(self, obj):
        if obj.status == 'available':
            return format_html('<span class="cm-badge cm-badge-resolved">Disponible</span>')
        return format_html('<span class="cm-badge cm-badge-ignored">Vendu</span>')

    @admin.action(description='✅ Marquer comme Disponible')
    def mark_available(self, request, queryset):
        n = queryset.update(status='available')
        self.message_user(request, f"{n} listing(s) marqué(s) comme disponible.")

    @admin.action(description='✔️ Marquer comme Vendu')
    def mark_sold(self, request, queryset):
        n = queryset.update(status='sold')
        self.message_user(request, f"{n} listing(s) marqué(s) comme vendu.")