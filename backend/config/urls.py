from django.contrib import admin

from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.views.generic import TemplateView
# ── Added by Nour (messaging module) ──────────────────────
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
# ──────────────────────────────────────────────────────────

urlpatterns = [
    path('admin/', admin.site.urls),
    path('auth/', include('features.authentication.urls')),  # ✅ corrigé
    # added to announcements
    path('api/', include('features.announcements.urls')),
    # ── Added by Nour (messaging module) ──────────────────
    path('api/messaging/', include('features.messaging.urls')),
    path('api/token/', TokenObtainPairView.as_view()),
    path('api/token/refresh/', TokenRefreshView.as_view()),
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema')),
    # ──────────────────────────────────────────────────────
    path('', TemplateView.as_view(template_name='home.html'), name='home'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
