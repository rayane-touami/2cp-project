from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('announcements', '0008_alter_announcement_student_id_alter_comment_user_id_and_more'),
    ]

    operations = [
        # Fix student_id: drop and recreate as UUID
        migrations.RunSQL(
            sql="""
                ALTER TABLE announcement DROP COLUMN IF EXISTS student_id;
                ALTER TABLE announcement ADD COLUMN student_id uuid;
                CREATE INDEX IF NOT EXISTS announcemen_student_58c7f2_idx ON announcement (student_id);
            """,
            reverse_sql=migrations.RunSQL.noop,
        ),
        # Fix comment.user_id
        migrations.RunSQL(
            sql="""
                ALTER TABLE comment DROP COLUMN IF EXISTS user_id;
                ALTER TABLE comment ADD COLUMN user_id uuid;
            """,
            reverse_sql=migrations.RunSQL.noop,
        ),
        # Fix favorite.user_id
        migrations.RunSQL(
            sql="""
                ALTER TABLE favorite DROP COLUMN IF EXISTS user_id;
                ALTER TABLE favorite ADD COLUMN user_id uuid;
            """,
            reverse_sql=migrations.RunSQL.noop,
        ),
        # Fix review.user_id
        migrations.RunSQL(
            sql="""
                ALTER TABLE review DROP COLUMN IF EXISTS user_id;
                ALTER TABLE review ADD COLUMN user_id uuid;
            """,
            reverse_sql=migrations.RunSQL.noop,
        ),
    ]