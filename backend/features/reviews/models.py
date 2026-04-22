from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from features.authentication.models import Student


class Review(models.Model):
    reviewer = models.ForeignKey(
        Student, on_delete=models.CASCADE, related_name='reviews_given'
    )
    target = models.ForeignKey(
        Student, on_delete=models.CASCADE, related_name='reviews_received'
    )
    score = models.PositiveSmallIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    comment = models.TextField(max_length=500, blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('reviewer', 'target')

    def __str__(self):
        return f'{self.reviewer.user.email} → {self.target.user.email} ({self.score}★)'