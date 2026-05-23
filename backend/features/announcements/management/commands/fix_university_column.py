from django.core.management.base import BaseCommand
from django.db import connection


class Command(BaseCommand):
    help = 'Fix missing and wrong-type columns in production DB'

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
            cursor.execute("""
                ALTER TABLE announcement DROP COLUMN IF EXISTS student_id;
            """)
            cursor.execute("""
                ALTER TABLE announcement ADD COLUMN student_id uuid;
            """)

            # Fix user_id type in favorite
            cursor.execute("""
                ALTER TABLE favorite DROP COLUMN IF EXISTS user_id;
            """)
            cursor.execute("""
                ALTER TABLE favorite ADD COLUMN user_id uuid;
            """)

        self.stdout.write('Done')