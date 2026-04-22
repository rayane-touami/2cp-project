from django.db.models.signals import post_save
from django.dispatch import receiver
from features.authentication.models import Student
from .models import Profile


@receiver(post_save, sender=Student)
def create_student_profile(sender, instance, created, **kwargs):
    """
    Auto-creates a Profile when a Student is created.
    """
    if created:
        Profile.objects.create(student=instance)