from django.db import models


class Profile(models.Model):
    """
    Extends Student model with marketplace-specific fields.
    Avatar, bio, university already exist on Student model.
    """

    # ─── LINK TO STUDENT ────────────────────────────────────
    student = models.OneToOneField(
        'authentication.Student',
        on_delete=models.CASCADE,
        related_name='profile'
    )

    # ─── TRUST & REPUTATION ─────────────────────────────────
    average_rating = models.DecimalField(
        max_digits=3, decimal_places=2, default=0.00
    )
    total_reviews = models.PositiveIntegerField(default=0)

    # ─── SELLER STATISTICS ──────────────────────────────────
    items_listed = models.PositiveIntegerField(default=0)
    completed_sales = models.PositiveIntegerField(default=0)
    response_rate = models.DecimalField(
        max_digits=5, decimal_places=2, default=0.00
    )
    response_time = models.CharField(max_length=100, blank=True, default='')

    # ─── ACTIVITY ───────────────────────────────────────────
    last_seen = models.DateTimeField(null=True, blank=True)

    # ─── SETTINGS ───────────────────────────────────────────
    notifications_enabled = models.BooleanField(default=True)
    show_email = models.BooleanField(default=False)
    is_active_seller = models.BooleanField(default=True)

    # ─── META ───────────────────────────────────────────────
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Profile of {self.student.user.email}"

    def is_verified(self):
        return self.student.verified