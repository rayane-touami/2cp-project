from django.core.management.base import BaseCommand
from django.db import connection


class Command(BaseCommand):
    help = 'Add missing university_id column'

    def handle(self, *args, **kwargs):
        with connection.cursor() as cursor:
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS university_id uuid NULL 
                REFERENCES university(id) ON DELETE SET NULL;
            """)
        self.stdout.write('Done')