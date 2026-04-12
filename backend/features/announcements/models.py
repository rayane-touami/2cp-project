from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from django.core.exceptions import ValidationError
from features.universities.models import University

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
        ARCHIVED = 'archived', 'Archived'
    
    title = models.CharField(max_length=200)
    description = models.TextField()
    price = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        validators=[MinValueValidator(0)]
    )
    
    student_id = models.UUIDField(db_index=True)  
    student_full_name = models.CharField(max_length=255) 
    category = models.ForeignKey(
        Category, 
        on_delete=models.SET_NULL, 
        null=True, 
        related_name='announcements'
    )
    
    university = models.ForeignKey(
        University,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='announcements'
    )
    
    # Contact information
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    whatsapp = models.CharField(max_length=20, blank=True, null=True)
    telegram = models.CharField(max_length=50, blank=True, null=True)
    instagram = models.CharField(max_length=50, blank=True, null=True)
    facebook = models.CharField(max_length=255, blank=True, null=True)
    allow_chat = models.BooleanField(default=True)

    location = models.CharField(max_length=255, blank=True)
    
    status = models.CharField(
        max_length=20, 
        choices=Status.choices, 
        default=Status.ACTIVE
    )
    views_count = models.PositiveIntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    condition = models.CharField(
        max_length=20,
        choices=[('new', 'New'), ('used', 'Used'), ('good', 'Good'), ('damaged', 'Damaged')],
        blank=True
    )
    url = models.URLField(blank=True, null=True)  
    
    class Meta:
        db_table = 'announcement'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['status', '-created_at']),
            models.Index(fields=['category']),
            models.Index(fields=['university']),
            models.Index(fields=['student_id']),
            models.Index(fields=['created_at']),
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
    position = models.PositiveSmallIntegerField(validators=[MinValueValidator(1), MaxValueValidator(10)])
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
        if self.position < 1 or self.position > 10:
            raise ValidationError({'position': 'Position must be between 1 and 10'})
        
class Favorite(models.Model):
    user_id = models.UUIDField(db_index=True)
    announcement = models.ForeignKey(
        Announcement, 
        on_delete=models.CASCADE, 
        related_name='favorited_by'
    )
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'favorite'
        unique_together = ['user_id', 'announcement']
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user_id', 'announcement']),
        ]
    
    def __str__(self):
        return f"User {self.user_id} favorites {self.announcement.title}"


class Review(models.Model):
    announcement = models.ForeignKey(
        Announcement, 
        on_delete=models.CASCADE, 
        related_name='reviews'
    )
    user_id = models.UUIDField(db_index=True)
    rating = models.IntegerField(
    choices=[(1, '1 Star'), (2, '2 Stars'), (3, '3 Stars'), (4, '4 Stars'), (5, '5 Stars')],
    validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    comment = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'review'
        unique_together = ['user_id', 'announcement']
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Review by {self.user_id} for {self.announcement.title}: {self.rating} stars"


class Comment(models.Model):
    announcement = models.ForeignKey(
        Announcement, 
        on_delete=models.CASCADE, 
        related_name='comments'
    )
    user_id = models.UUIDField(db_index=True)
    parent = models.ForeignKey(
        'self', 
        null=True, 
        blank=True, 
        on_delete=models.CASCADE, 
        related_name='replies'
    )
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'comment'
        ordering = ['created_at']
    
    def __str__(self):

        return f"Comment by {self.user_id} on {self.announcement.title}"


