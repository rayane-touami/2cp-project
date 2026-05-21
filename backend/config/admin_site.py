# config/admin_site.py
# ──────────────────────────────────────────────────────────────────────────────
# Personnalisation globale du site admin Django
# À importer dans config/urls.py
# ──────────────────────────────────────────────────────────────────────────────

from django.contrib import admin


# ══════════════════════════════════════════════════════════════════════════════
#  Titres & branding
# ══════════════════════════════════════════════════════════════════════════════

admin.site.site_header  = "🎓 Campus Market — Admin"
admin.site.site_title   = "Campus Market"
admin.site.index_title  = "Tableau de bord"


# ══════════════════════════════════════════════════════════════════════════════
#  Ordre des apps dans le menu latéral
# ══════════════════════════════════════════════════════════════════════════════
# Surcharge get_app_list pour imposer l'ordre qu'on veut

_original_get_app_list = admin.AdminSite.get_app_list

def _custom_get_app_list(self, request, app_label=None):
    app_list = _original_get_app_list(self, request, app_label)

    ORDER = [
        'announcements',   # Annonces & Reports (priorité)
        'authentication',  # Users
        'universities',
        'messaging',
        'notifications',
        'moderation',
    ]

    def _sort_key(app):
        label = app['app_label']
        try:
            return ORDER.index(label)
        except ValueError:
            return len(ORDER)

    app_list.sort(key=_sort_key)
    return app_list

admin.AdminSite.get_app_list = _custom_get_app_list


# ══════════════════════════════════════════════════════════════════════════════
#  CSS personnalisé (sera complété quand tu donneras les couleurs)
# ══════════════════════════════════════════════════════════════════════════════
#
# Crée le fichier  static/admin/css/custom_admin.css  dans ton projet,
# puis dans chaque ModelAdmin qui en a besoin, ajoute :
#
#   class Media:
#       css = {'all': ('admin/css/custom_admin.css',)}
#
# Ou globalement via une surcharge du template admin/base.html :
#
#   {% block extrastyle %}
#       {{ block.super }}
#       <link rel="stylesheet" href="{% static 'admin/css/custom_admin.css' %}">
#   {% endblock %}
#
# ──────────────────────────────────────────────────────────────────────────────


# ══════════════════════════════════════════════════════════════════════════════
#  Exemple de CSS  (à remplacer par tes vraies couleurs)
#  Fichier : static/admin/css/custom_admin.css
# ══════════════════════════════════════════════════════════════════════════════

PLACEHOLDER_CSS = """
/* ── Variables couleurs (à adapter à ton design) ─────────────────────────── */
:root {
  --primary:       #7c3aed;   /* violet — à remplacer */
  --primary-dark:  #5b21b6;
  --secondary:     #0ea5e9;
  --danger:        #dc2626;
  --success:       #16a34a;
  --bg-sidebar:    #1e1b4b;
  --text-sidebar:  #e0e7ff;
}

/* ── Header ─────────────────────────────────────────────────────────────── */
#header {
  background: var(--primary-dark);
  color: #fff;
}
#header a:link, #header a:visited { color: #fff; }
#branding h1 a { color: #fff !important; font-weight: 700; }
#user-tools a  { color: #c4b5fd; }

/* ── Navigation sidebar ──────────────────────────────────────────────────── */
#nav-sidebar { background: var(--bg-sidebar); }
.module caption, .inline-group h2 {
  background: var(--primary);
  color: #fff;
}
.module h2 { background: var(--primary-dark); color: #fff; }

/* ── Boutons ─────────────────────────────────────────────────────────────── */
.button, input[type=submit], input[type=button], .submit-row input {
  background: var(--primary);
  border-color: var(--primary-dark);
}
.button:hover, input[type=submit]:hover {
  background: var(--primary-dark);
}
.button.default { background: var(--primary-dark); }

/* ── Liens ───────────────────────────────────────────────────────────────── */
a:link, a:visited { color: var(--primary); }

/* ── Dashboard cards ──────────────────────────────────────────────────────── */
.dashboard .module table td a { font-weight: 600; }
"""

# Écris ce CSS dans le bon fichier :
# import os
# css_path = os.path.join(BASE_DIR, 'static', 'admin', 'css', 'custom_admin.css')
# os.makedirs(os.path.dirname(css_path), exist_ok=True)
# with open(css_path, 'w') as f:
#     f.write(PLACEHOLDER_CSS)