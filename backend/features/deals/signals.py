from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Deal


@receiver(post_save, sender=Deal)
def update_completed_sales(sender, instance, **kwargs):
    if instance.status == Deal.Status.COMPLETED:
        try:
            profile = instance.seller.profile
            profile.completed_sales = Deal.objects.filter(
                seller=instance.seller,
                status=Deal.Status.COMPLETED
            ).count()
            profile.save(update_fields=['completed_sales'])
        except Exception:
            pass