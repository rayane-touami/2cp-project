from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.db.models import Avg
from .models import Review


def recalculate_rating(target_student):
    reviews = Review.objects.filter(target=target_student)
    total = reviews.count()
    average = reviews.aggregate(Avg('score'))['score__avg'] or 0.00
    try:
        profile = target_student.profile
        profile.total_reviews = total
        profile.average_rating = round(average, 2)
        profile.save(update_fields=['total_reviews', 'average_rating'])
    except Exception:
        pass


@receiver(post_save, sender=Review)
def update_rating_on_save(sender, instance, **kwargs):
    recalculate_rating(instance.target)


@receiver(post_delete, sender=Review)
def update_rating_on_delete(sender, instance, **kwargs):
    recalculate_rating(instance.target)