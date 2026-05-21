from django.contrib import admin
from django.utils import timezone
from django.utils.html import format_html
from features.announcements.models import Report, Announcement


@admin.register(Report)
class ReportAdmin(admin.ModelAdmin):

    list_display   = ('id', 'announcement_link', 'reason', 'status_badge', 'reporter_id', 'created_at')
    list_filter    = ('status', 'reason', 'created_at')
    search_fields  = ('announcement__title', 'description')
    ordering       = ('-created_at',)
    date_hierarchy = 'created_at'

    @admin.display(description='Annonce')
    def announcement_link(self, obj):
        return format_html(
            '<a href="/admin/announcements/announcement/{}/change/">{}</a>',
            obj.announcement.id,
            obj.announcement.title[:60]
        )

    @admin.display(description='Statut')
    def status_badge(self, obj):
        styles = {
            'pending':  ('#d97706', '🕐 En attente'),
            'resolved': ('#16a34a', '✅ Résolu'),
            'ignored':  ('#6b7280', '❌ Ignoré'),
        }
        color, label = styles.get(obj.status, ('#6b7280', obj.status))
        return format_html(
            '<span style="color:{};font-weight:bold;">{}</span>', color, label
        )

    fieldsets = (
        ("Signalement soumis par l'étudiant", {
            'fields': ('announcement', 'reporter_id', 'reason', 'description', 'created_at')
        }),
        ("Décision de l'admin", {
            'fields': ('status', 'reviewed_by', 'reviewed_at'),
        }),
    )
    readonly_fields = (
        'announcement', 'reporter_id', 'reason',
        'description', 'created_at', 'reviewed_by', 'reviewed_at'
    )

    def has_add_permission(self, request):
        return False

    actions = ['resolve_reports', 'ignore_reports']

    @admin.action(description='✅ Résoudre — archiver les annonces correspondantes')
    def resolve_reports(self, request, queryset):
        pending = queryset.filter(status=Report.Status.PENDING)
        count   = 0
        for report in pending:
            report.status      = Report.Status.RESOLVED
            report.reviewed_by = request.user
            report.reviewed_at = timezone.now()
            report.save()
            report.announcement.status = Announcement.Status.ARCHIVED
            report.announcement.save(update_fields=['status'])
            count += 1
        self.message_user(request, f"{count} report(s) résolu(s). Annonces archivées.")

    @admin.action(description='❌ Ignorer les reports sélectionnés')
    def ignore_reports(self, request, queryset):
        pending = queryset.filter(status=Report.Status.PENDING)
        count   = 0
        for report in pending:
            report.status      = Report.Status.IGNORED
            report.reviewed_by = request.user
            report.reviewed_at = timezone.now()
            report.save()
            count += 1
        self.message_user(request, f"{count} report(s) ignoré(s).")
