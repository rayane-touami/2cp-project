import uuid
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
from features.universities.models import University
import random 
from datetime import timedelta

class UserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Email obligatoire')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True)
    full_name = models.CharField(max_length=255)
    phone = models.CharField(max_length=20, null=True, blank=True)
    created_at = models.DateTimeField(default=timezone.now)
    is_active = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['full_name']

    objects = UserManager()

    def __str__(self):
        return self.email
    
class Student(models.Model):
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name='student_profile'
    )
    university = models.ForeignKey(
    'universities.University',  
    on_delete=models.SET_NULL, null=True
    )
    student_id = models.CharField(max_length=50, null=True, blank=True)
    #  Pour l'instant pas de vérification email universitaire
    verified = models.BooleanField(default=True)
    profile_picture = models.ImageField(
        upload_to='students/photos/', null=True, blank=True
    )
    campus_location = models.CharField(max_length=255, null=True, blank=True)
    description = models.TextField(null=True, blank=True)

    def __str__(self):
        return f"{self.user.full_name}"

class EmailVerification(models.Model):
    """
    Table unique pour les 2 cas : inscription et reset mot de passe.
    Le champ `purpose` distingue les deux.
    """
    PURPOSE_REGISTER       = 'register'
    PURPOSE_RESET_PASSWORD = 'reset_password'
    PURPOSE_CHOICES = [
        (PURPOSE_REGISTER,       'Inscription'),
        (PURPOSE_RESET_PASSWORD, 'Réinitialisation mot de passe'),
    ]

    user       = models.ForeignKey(User, on_delete=models.CASCADE, related_name='verifications')
    code       = models.CharField(max_length=6)
    purpose    = models.CharField(max_length=20, choices=PURPOSE_CHOICES)
    is_used    = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()

    class Meta:
        ordering = ['-created_at']

    @classmethod
    def generate_for(cls, user, purpose):
        """Invalide les anciens codes du même type, crée un nouveau."""
        cls.objects.filter(user=user, purpose=purpose, is_used=False).update(is_used=True)
        code = f"{random.randint(0, 999999):06d}"
        return cls.objects.create(
            user=user,
            code=code,
            purpose=purpose,
            expires_at=timezone.now() + timedelta(minutes=15),
        )

    def is_valid(self):
        return not self.is_used and timezone.now() < self.expires_at

    def __str__(self):
        return f"{self.user.email} — {self.purpose} — {self.code}"