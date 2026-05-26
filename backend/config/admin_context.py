 
from django.contrib.admin import AdminSite
 
_original_index = AdminSite.index
 
 
def _patched_index(self, request, extra_context=None):
    try:
        from features.authentication.models import Student
        from features.announcements.models import Announcement, Report
 
        stats = {
            # ── Cartes stats du mockup ──────────────────────────
            "total_students":    Student.objects.count(),
            "pending_approvals": Announcement.objects.filter(status="draft").count(),
            "active_listings":   Announcement.objects.filter(status="active").count(),
            "flagged_reports":   Report.objects.filter(status="pending").count(),
 
            # ── Tableau "Recently Uploaded Products" ────────────
            # On affiche les 5 dernières annonces en draft (= en attente d'approbation)
            "recent_announcements": (
                Announcement.objects
                .select_related("university", "category")
                .filter(status="draft")
                .order_by("-created_at")[:5]
            ),
 
            # ── Tableau "User Verification Queue" ───────────────
            # Étudiants dont le compte user n'est pas encore actif
            "pending_students": (
                Student.objects
                .select_related("user", "university")
                .filter(user__is_active=False)
                .order_by("-user__created_at")[:5]
            ),
        }
    except Exception:
        # Évite un crash si les migrations ne sont pas encore faites
        stats = {
            "total_students": 0,
            "pending_approvals": 0,
            "active_listings": 0,
            "flagged_reports": 0,
            "recent_announcements": [],
            "pending_students": [],
        }
 
    if extra_context:
        stats.update(extra_context)
 
    return _original_index(self, request, stats)
 
 
AdminSite.index = _patched_index