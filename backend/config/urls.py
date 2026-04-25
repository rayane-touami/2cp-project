from django.contrib import admin

from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.views.generic import TemplateView
# ──  (messaging module) ──────────────────────
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
# ──────────────────────────────────────────────────────────

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('features.authentication.urls')),
    path('api/', include('features.announcements.urls')),
    # ──  (messaging module) ──────────────────
    path('api/messaging/', include('features.messaging.urls')),
    path('api/token/', TokenObtainPairView.as_view()),
    path('api/token/refresh/', TokenRefreshView.as_view()),
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema')),

    path('api/', include('features.universities.urls')),

    # Notifications API
    path('api/', include('features.notifications.urls')),
    # ── (profile module) ─────────────────
    path('api/profiles/', include('features.accounts.urls')),
    path('api/listings/', include('features.listings.urls')),
    path('api/reviews/', include('features.reviews.urls')),
    path('api/deals/', include('features.deals.urls')),
    path('api/users/', include('features.accounts.user_urls')),
    # ──────────────────────────────────────────────────────
    path('', SpectacularSwaggerView.as_view(url_name='schema'), name='home'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
