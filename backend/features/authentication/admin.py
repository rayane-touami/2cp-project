from django.contrib import admin


from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.html import format_html
from django.utils import timezone
from django.db.models import Count
from .models import User, Student, EmailVerification


# ══════════════════════════════════════════════════════════════════════════════
#  INLINE : Student dans User
# ══════════════════════════════════════════════════════════════════════════════

class StudentInline(admin.StackedInline):
    model   = Student
    extra   = 0
    fields  = ('university', 'student_id', 'verified', 'campus_location',
                'description', 'profile_picture')
    readonly_fields = ('profile_picture',)


# ══════════════════════════════════════════════════════════════════════════════
#  USER ADMIN
# ══════════════════════════════════════════════════════════════════════════════

@admin.register(User)
class UserAdmin(BaseUserAdmin):
    inlines         = [StudentInline]
    list_display    = ('email', 'full_name', 'phone', 'is_active',
                       'is_staff', 'role_badge', 'announcements_count', 'created_at')
    list_filter     = ('is_active', 'is_staff', 'is_superuser')
    search_fields   = ('email', 'full_name', 'phone')
    ordering        = ('-created_at',)
    readonly_fields = ('id', 'created_at', 'last_login')

    # Champs affichés dans le formulaire de détail
    fieldsets = (
        ('Identité', {
            'fields': ('id', 'email', 'full_name', 'phone', 'password')
        }),
        ('Statut du compte', {
            'fields': ('is_active', 'created_at', 'last_login')
        }),
        ('Rôle admin', {
            'fields': ('is_staff', 'is_superuser'),
            'classes': ('collapse',),
            'description': '⚠️ Réservé aux Owners. '
                           'is_staff = Admin | is_superuser = Owner',
        }),
        ('Permissions détaillées', {
            'fields': ('groups', 'user_permissions'),
            'classes': ('collapse',),
        }),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'full_name', 'phone', 'password1', 'password2',
                       'is_active', 'is_staff'),
        }),
    )

    # ── Colonne "Rôle" avec badge coloré ─────────────────────────────────────
    @admin.display(description='Rôle')
    def role_badge(self, obj):
        if obj.is_superuser:
            return format_html(
                '<span style="background:#7c3aed;color:#fff;padding:2px 8px;'
                'border-radius:4px;font-size:11px;">👑 Owner</span>'
            )
        if obj.is_staff:
            return format_html(
                '<span style="background:#0284c7;color:#fff;padding:2px 8px;'
                'border-radius:4px;font-size:11px;">🛡 Admin</span>'
            )
        return format_html(
            '<span style="background:#6b7280;color:#fff;padding:2px 8px;'
            'border-radius:4px;font-size:11px;">👤 User</span>'
        )

    # ── Nombre d'annonces ────────────────────────────────────────────────────
    @admin.display(description='Annonces')
    def announcements_count(self, obj):
        # student_id dans Announcement est un UUID = user.id
        from features.announcements.models import Announcement
        count = Announcement.objects.filter(student_id=obj.id).count()
        return count

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        # Un admin (non-owner) ne voit pas les autres admins/owners
        if not request.user.is_superuser:
            qs = qs.filter(is_staff=False, is_superuser=False)
        return qs

    def get_readonly_fields(self, request, obj=None):
        """
        Un admin ne peut pas modifier les champs de permission.
        Seul le owner peut promouvoir/rétrograder.
        """
        rf = list(super().get_readonly_fields(request, obj))
        if not request.user.is_superuser:
            rf += ['is_staff', 'is_superuser', 'groups', 'user_permissions']
        return rf

    def has_delete_permission(self, request, obj=None):
        """
        Un admin peut supprimer des users normaux.
        Seul le owner peut supprimer un admin/owner.
        """
        if obj and (obj.is_staff or obj.is_superuser):
            return request.user.is_superuser
        return super().has_delete_permission(request, obj)

    # Actions sur la liste
    actions = ['activate_users', 'deactivate_users']

    @admin.action(description='✅ Activer les comptes sélectionnés')
    def activate_users(self, request, queryset):
        updated = queryset.update(is_active=True)
        self.message_user(request, f'{updated} compte(s) activé(s).')

    @admin.action(description='🚫 Désactiver les comptes sélectionnés')
    def deactivate_users(self, request, queryset):
        updated = queryset.update(is_active=False)
        self.message_user(request, f'{updated} compte(s) désactivé(s).')


# ══════════════════════════════════════════════════════════════════════════════
#  EMAIL VERIFICATION — lecture seule pour l'admin
# ══════════════════════════════════════════════════════════════════════════════

@admin.register(EmailVerification)
class EmailVerificationAdmin(admin.ModelAdmin):
    list_display  = ('user', 'purpose', 'code', 'is_used', 'expires_at', 'created_at')
    list_filter   = ('purpose', 'is_used')
    search_fields = ('user__email',)
    readonly_fields = ('user', 'code', 'purpose', 'is_used', 'created_at', 'expires_at')
    ordering      = ('-created_at',)

    def has_add_permission(self, request):
        return False   # géré programmatiquement uniquement

    def has_change_permission(self, request, obj=None):
        return False
    
    