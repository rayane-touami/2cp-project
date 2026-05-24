from django.core.management.base import BaseCommand
from features.authentication.models import Student
from features.accounts.models import Profile


class Command(BaseCommand):
    help = 'Creates missing Profile objects for existing Students'

    def handle(self, *args, **kwargs):
        fixed = 0
        for student in Student.objects.all():
            _, created = Profile.objects.get_or_create(student=student)
            if created:
                self.stdout.write(f"Created profile for: {student.user.email}")
                fixed += 1
        self.stdout.write(self.style.SUCCESS(f"Done. Fixed {fixed} accounts."))