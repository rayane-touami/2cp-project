# 2cp-project
 Campus Marketplace — Backend Django

⚠️ IMPORTANT POUR TOUTE L'ÉQUIPE : Ne pas modifier le dossier config/ sans en parler d'abord au lead dev. Ce dossier contient la configuration globale du projet (settings, urls principal, wsgi). Toute modification peut casser l'ensemble du projet.


Description

Application marketplace destinée aux étudiants algériens. Permet de publier, rechercher et échanger des annonces (livres, matériel, services...) entre étudiants d'une même université.
Stack technique :

Backend web : Django 4.x
Mobile : Flutter (phase 2)
API : Django REST Framework (phase 2)
Base de données : SQLite (dev) → PostgreSQL (prod)


🗂️ Architecture du projet
backend/
│
├── config/                        ⚠️ NE PAS TOUCHER
│   ├── settings.py                    Configuration globale
│   ├── urls.py                        Routage principal
│   └── wsgi.py
│
├── features/                      ✅ Tout le code métier ici
│   ├── __init__.py
│   │
│   ├── authentication/            Inscription, connexion, profil
│   │   ├── migrations/
│   │   ├── fixtures/
│   │   ├── models.py              → User, Student
│   │   ├── views.py               → register, login, logout, profile
│   │   ├── forms.py               → RegisterForm, LoginForm
│   │   ├── urls.py                → /auth/...
│   │   └── apps.py
│   │
│   ├── universities/              Gestion des universités
│   │   ├── migrations/
│   │   ├── fixtures/
│   │   │   └── universities.json  → 53 universités algériennes
│   │   ├── models.py              → University
│   │   └── apps.py
│   │
│   ├── announcements/             Annonces marketplace (à venir)
│   │   └── ...
│   │
│   ├── messaging/                 Messagerie entre étudiants (à venir)
│   │   └── ...
│   │
│   └── moderation/                Signalements & admin (à venir)
│       └── ...
│
├── templates/                     Templates HTML
│   ├── base.html
│   ├── home.html
│   └── users/
│       ├── register.html
│       └── login.html
│
├── media/                         Photos uploadées (auto-créé)
├── manage.py
└── requirements.txt