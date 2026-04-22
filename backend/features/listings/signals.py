from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from .models import Listing


@receiver(post_save, sender=Listing)
def update_items_listed_on_save(sender, instance, **kwargs):
    try:
        profile = instance.seller.profile
        profile.items_listed = Listing.objects.filter(
            seller=instance.seller,
            status=Listing.Status.AVAILABLE
        ).count()
        profile.save(update_fields=['items_listed'])
    except Exception:
        pass


@receiver(post_delete, sender=Listing)
def update_items_listed_on_delete(sender, instance, **kwargs):
    try:
        profile = instance.seller.profile
        profile.items_listed = Listing.objects.filter(
            seller=instance.seller,
            status=Listing.Status.AVAILABLE
        ).count()
        profile.save(update_fields=['items_listed'])
    except Exception:
        pass