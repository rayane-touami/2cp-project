import uuid
from django.db import models

class University(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    location = models.CharField(max_length=255)
    logo = models.ImageField(upload_to='universities/logos/', null=True, blank=True)
    domain = models.CharField(max_length=100, unique=True, help_text='ex: univ-oran.dz')
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)

    class Meta:
        verbose_name_plural = 'Universities'

    def __str__(self):
        return self.name