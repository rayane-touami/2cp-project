from django.core.management.base import BaseCommand
from features.announcements.models import Announcement
from features.authentication.models import User

class Command(BaseCommand):
    help = 'Fix null student_id on announcements'

    def handle(self, *args, **kwargs):
        fixed = 0
        skipped = 0
        for a in Announcement.objects.filter(student_id__isnull=True):
            try:
                user = User.objects.get(full_name=a.student_full_name)
                a.student_id = user.id
                a.save(update_fields=['student_id'])
                self.stdout.write(f"Fixed: {a.title} → {user.id}")
                fixed += 1
            except User.DoesNotExist:
                self.stdout.write(f"Skipped (user not found): {a.student_full_name}")
                skipped += 1
            except User.MultipleObjectsReturned:
                self.stdout.write(f"Skipped (multiple users): {a.student_full_name}")
                skipped += 1
        self.stdout.write(f"\nDone: {fixed} fixed, {skipped} skipped")