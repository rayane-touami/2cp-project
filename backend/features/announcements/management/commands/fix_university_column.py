from django.core.management.base import BaseCommand
from django.db import connection


class Command(BaseCommand):
    help = 'Add missing columns to announcement table'

    def handle(self, *args, **kwargs):
        with connection.cursor() as cursor:
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS university_id uuid NULL REFERENCES university(id) ON DELETE SET NULL;
            """)
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS phone_number varchar(20) NULL;
            """)
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS whatsapp varchar(20) NULL;
            """)
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS telegram varchar(50) NULL;
            """)
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS instagram varchar(50) NULL;
            """)
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS facebook varchar(255) NULL;
            """)
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS allow_chat boolean NOT NULL DEFAULT true;
            """)
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS condition varchar(20) NOT NULL DEFAULT '';
            """)
            cursor.execute("""
                ALTER TABLE announcement 
                ADD COLUMN IF NOT EXISTS url varchar(200) NULL;
            """)
        self.stdout.write('Done')