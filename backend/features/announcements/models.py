# models.py
from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from django.core.exceptions import ValidationError
import os

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)
    icon = models.CharField(max_length=50, blank=True, help_text="Icon name for Flutter")
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        verbose_name_plural = "categories"
        db_table = 'category'
        ordering = ['name']
        indexes = [
            models.Index(fields=['name']),
        ]
    
    def __str__(self):
        return self.name

class Announcement(models.Model):
   
    class Status(models.TextChoices):
        ACTIVE = 'active', 'Active'
        SOLD = 'sold', 'Sold'
        EXPIRED = 'expired', 'Expired'
        DRAFT = 'draft', 'Draft'
    
   
    title = models.CharField(max_length=200)
    description = models.TextField()
    price = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        validators=[MinValueValidator(0)]
    )
    
    
    student_id = models.IntegerField(db_index=True)  
    student_full_name = models.CharField(max_length=255) 
    category = models.ForeignKey(
        Category, 
        on_delete=models.SET_NULL, 
        null=True, 
        related_name='announcements'
    )
    
    
    location = models.CharField(max_length=255, blank=True)
    
    
    status = models.CharField(
        max_length=20, 
        choices=Status.choices, 
        default=Status.ACTIVE
    )
    views_count = models.PositiveIntegerField(default=0)
    
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'announcement'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['status', '-created_at']),
            models.Index(fields=['category']),
            models.Index(fields=['student_id']),
            models.Index(fields=['created_at']),  # index for sorting
        ]
    
    def __str__(self):
        return f"{self.title} - {self.price} DH"

class Photo(models.Model):
    announcement = models.ForeignKey(
        Announcement, 
        on_delete=models.CASCADE, 
        related_name='photos'
    )
    image = models.ImageField(upload_to='announcements/%Y/%m/%d/') 
    position = models.PositiveSmallIntegerField(validators=[MaxValueValidator(10)])  # Max 10 photos
    uploaded_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'photo'
        ordering = ['position']
        constraints = [
            models.UniqueConstraint(
                fields=['announcement', 'position'],
                name='unique_photo_position'
            )
        ]
        indexes = [
            models.Index(fields=['announcement', 'position']),
        ]
    
    def __str__(self):
        return f"Photo {self.position} for {self.announcement.title}"
    
    @property
    def url(self):
        if self.image:
            return self.image.url
        return None
    
    def clean(self):
        if self.position < 1 or self.position > 5:
            raise ValidationError({'position': 'Position must be between 1 and 5'})
