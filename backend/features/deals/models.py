from django.db import models
from features.authentication.models import Student
from features.listings.models import Listing


class Deal(models.Model):

    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        ACCEPTED = 'accepted', 'Accepted'
        COMPLETED = 'completed', 'Completed'
        CANCELLED = 'cancelled', 'Cancelled'

    buyer = models.ForeignKey(
        Student, on_delete=models.CASCADE, related_name='deals_as_buyer'
    )
    seller = models.ForeignKey(
        Student, on_delete=models.CASCADE, related_name='deals_as_seller'
    )
    listing = models.ForeignKey(
        Listing, on_delete=models.CASCADE, related_name='deals'
    )
    status = models.CharField(
        max_length=20, choices=Status.choices, default=Status.PENDING
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'Deal: {self.buyer.user.email} → {self.seller.user.email} [{self.status}]'