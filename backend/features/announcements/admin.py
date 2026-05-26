from django.contrib import admin
from django.utils.html import format_html
from django.utils import timezone
from .models import Announcement, Category, Photo, Favorite, Review, Comment


# ══════════════════════════════════════════════════════════════════
#  PHOTO — inline dans Announcement
# ══════════════════════════════════════════════════════════════════
class PhotoInline(admin.TabularInline):
    model          = Photo
    extra          = 0
    max_num        = 10
    readonly_fields = ('image_preview', 'uploaded_at')
    fields         = ('image', 'image_preview', 'position', 'uploaded_at')

    @admin.display(description='Aperçu')
    def image_preview(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" height="60" style="border-radius:6px; object-fit:cover;"/>',
                obj.image.url
            )
        return '—'


# ══════════════════════════════════════════════════════════════════
#  CATEGORY
# ══════════════════════════════════════════════════════════════════
@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display  = ('icon_display', 'name', 'description_short', 'announcement_count', 'created_at')
    search_fields = ('name', 'description')
    ordering      = ('name',)

    @admin.display(description='')
    def icon_display(self, obj):
        if obj.icon:
            return format_html('<i class="{}" style="font-size:16px; color:#3076E0;"></i>', obj.icon)
        return format_html('<i class="fas fa-tag" style="font-size:16px; color:#6B7A90;"></i>')

    @admin.display(description='Description')
    def description_short(self, obj):
        return obj.description[:60] + '…' if len(obj.description) > 60 else obj.description or '—'

    @admin.display(description='Annonces')
    def announcement_count(self, obj):
        count = obj.announcements.count()
        return format_html('<strong style="color:#3076E0;">{}</strong>', count)


# ══════════════════════════════════════════════════════════════════
#  ANNOUNCEMENT
# ══════════════════════════════════════════════════════════════════
@admin.register(Announcement)
class AnnouncementAdmin(admin.ModelAdmin):
    list_display   = (
        'title', 'price_display', 'category', 'university',
        'status_badge', 'condition_badge', 'views_count', 'created_at'
    )
    list_filter    = ('status', 'category', 'university', 'condition')
    search_fields  = ('title', 'description', 'student_full_name', 'location')
    readonly_fields = ('views_count', 'created_at', 'updated_at', 'student_id')
    ordering       = ('-created_at',)
    date_hierarchy = 'created_at'
    inlines        = [PhotoInline]
    list_per_page  = 25

    fieldsets = (
        ('Informations principales', {
            'fields': ('title', 'description', 'price', 'condition', 'url')
        }),
        ('Étudiant & Université', {
            'fields': ('student_id', 'student_full_name', 'university', 'location')
        }),
        ('Classification', {
            'fields': ('category', 'status')
        }),
        ('Contact', {
            'fields': ('phone_number', 'whatsapp', 'telegram', 'instagram', 'facebook', 'allow_chat'),
            'classes': ('collapse',),
        }),
        ('Statistiques', {
            'fields': ('views_count', 'created_at', 'updated_at'),
            'classes': ('collapse',),
        }),
    )

    actions = ['mark_active', 'mark_draft', 'mark_archived', 'mark_sold']

    # ── Colonnes custom ─────────────────────────────────────────
    @admin.display(description='Prix')
    def price_display(self, obj):
        return format_html('<strong style="color:#1A2535;">{} DA</strong>', obj.price)

    @admin.display(description='Statut')
    def status_badge(self, obj):
        mapping = {
            'active':   ('cm-badge-resolved', 'Active'),
            'sold':     ('cm-badge-ignored',  'Sold'),
            'expired':  ('cm-badge-pending',  'Expired'),
            'draft':    ('cm-badge-spam',     'Draft'),
            'archived': ('cm-badge-scam',     'Archived'),
        }
        cls, label = mapping.get(obj.status, ('cm-badge-other', obj.status))
        return format_html('<span class="cm-badge {}">{}</span>', cls, label)

    @admin.display(description='État')
    def condition_badge(self, obj):
        if not obj.condition:
            return format_html('<span style="color:#6B7A90;">—</span>')
        mapping = {
            'new':     ('cm-badge-resolved', 'Neuf'),
            'good':    ('cm-badge-spam',     'Bon état'),
            'used':    ('cm-badge-pending',  'Usagé'),
            'damaged': ('cm-badge-scam',     'Endommagé'),
        }
        cls, label = mapping.get(obj.condition, ('cm-badge-other', obj.condition))
        return format_html('<span class="cm-badge {}">{}</span>', cls, label)

    # ── Actions bulk ────────────────────────────────────────────
    @admin.action(description='✅ Approuver → Active')
    def mark_active(self, request, queryset):
        n = queryset.update(status='active')
        self.message_user(request, f"{n} annonce(s) approuvée(s).")

    @admin.action(description='📝 Repasser en Draft')
    def mark_draft(self, request, queryset):
        n = queryset.update(status='draft')
        self.message_user(request, f"{n} annonce(s) repassée(s) en draft.")

    @admin.action(description='📦 Archiver')
    def mark_archived(self, request, queryset):
        n = queryset.update(status='archived')
        self.message_user(request, f"{n} annonce(s) archivée(s).")

    @admin.action(description='✔️ Marquer comme Vendue')
    def mark_sold(self, request, queryset):
        n = queryset.update(status='sold')
        self.message_user(request, f"{n} annonce(s) marquée(s) comme vendue.")



# ══════════════════════════════════════════════════════════════════
#  REVIEW (sur annonce)
# ══════════════════════════════════════════════════════════════════
@admin.register(Review)
class AnnouncementReviewAdmin(admin.ModelAdmin):
    list_display  = ('announcement', 'user_id', 'rating_stars', 'comment_preview', 'created_at')
    list_filter   = ('rating',)
    search_fields = ('announcement__title', 'comment')
    ordering      = ('-created_at',)
    readonly_fields = ('user_id', 'announcement', 'created_at', 'updated_at')

    @admin.display(description='Note')
    def rating_stars(self, obj):
        filled = '★' * obj.rating
        empty  = '☆' * (5 - obj.rating)
        color  = '#F59E0B' if obj.rating >= 3 else '#EF4444'
        return format_html(
            '<span style="color:{}; font-size:15px; letter-spacing:1px;">{}</span>'
            '<span style="color:#D1D5DB; font-size:15px;">{}</span>',
            color, filled, empty
        )

    @admin.display(description='Commentaire')
    def comment_preview(self, obj):
        return obj.comment[:80] + '…' if len(obj.comment) > 80 else obj.comment


# ══════════════════════════════════════════════════════════════════
#  COMMENT
# ══════════════════════════════════════════════════════════════════
@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display  = ('announcement', 'user_id', 'is_reply', 'content_preview', 'created_at')
    list_filter   = ('created_at',)
    search_fields = ('announcement__title', 'content')
    ordering      = ('-created_at',)
    readonly_fields = ('user_id', 'announcement', 'parent', 'created_at', 'updated_at')

    @admin.display(description='Réponse ?')
    def is_reply(self, obj):
        if obj.parent:
            return format_html('<span class="cm-badge cm-badge-spam">↩ Réponse</span>')
        return format_html('<span class="cm-badge cm-badge-student">Commentaire</span>')

    @admin.display(description='Contenu')
    def content_preview(self, obj):
        return obj.content[:80] + '…' if len(obj.content) > 80 else obj.content


# ══════════════════════════════════════════════════════════════════
#  FAVORITE
# ══════════════════════════════════════════════════════════════════
@admin.register(Favorite)
class FavoriteAdmin(admin.ModelAdmin):
    list_display  = ('user_id', 'announcement', 'created_at')
    search_fields = ('announcement__title',)
    ordering      = ('-created_at',)
    readonly_fields = ('user_id', 'announcement', 'created_at')

    def has_add_permission(self, request):
        return False