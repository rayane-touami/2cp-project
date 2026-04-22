from django.db import models

# Create your models here.
from django.db import models
from features.authentication.models import Student


def listing_image_upload_path(instance, filename):
    return f'listings/student_{instance.seller.id}/{filename}'


class Listing(models.Model):

    class Category(models.TextChoices):
        BOOKS = 'books', 'Books'
        TECH = 'tech', 'Tech'
        CLOTHES = 'clothes', 'Clothes'
        FURNITURE = 'furniture', 'Furniture'
        SPORTS = 'sports', 'Sports'
        OTHER = 'other', 'Other'

    class Condition(models.TextChoices):
        NEW = 'new', 'New'
        USED = 'used', 'Used'

    class Status(models.TextChoices):
        AVAILABLE = 'available', 'Available'
        SOLD = 'sold', 'Sold'

    seller = models.ForeignKey(
        Student, on_delete=models.CASCADE, related_name='listings'
    )
    title = models.CharField(max_length=200)
    description = models.TextField(max_length=1000, blank=True, default='')
    price = models.DecimalField(max_digits=10, decimal_places=2)
    currency = models.CharField(max_length=10, default='DZD')
    category = models.CharField(
        max_length=20, choices=Category.choices, default=Category.OTHER
    )
    condition = models.CharField(
        max_length=10, choices=Condition.choices, default=Condition.USED
    )
    status = models.CharField(
        max_length=20, choices=Status.choices, default=Status.AVAILABLE
    )
    image = models.ImageField(
        upload_to=listing_image_upload_path, null=True, blank=True
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.title} by {self.seller.user.email}'