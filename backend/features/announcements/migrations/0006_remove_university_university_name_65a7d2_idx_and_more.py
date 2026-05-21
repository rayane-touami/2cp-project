import django.core.validators
import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('announcements', '0005_announcement_condition_announcement_url'),
        ('universities', '0002_university_latitude_university_longitude'),
    ]

    operations = [
        migrations.RemoveIndex(
            model_name='university',
            name='university_name_65a7d2_idx',
        ),
        migrations.RunSQL(
            sql="""
                ALTER TABLE announcement DROP COLUMN IF EXISTS university_id;
                ALTER TABLE announcement ADD COLUMN university_id uuid NULL REFERENCES universities_university(id) ON DELETE SET NULL;
            """,
            reverse_sql="""
                ALTER TABLE announcement DROP COLUMN IF EXISTS university_id;
                ALTER TABLE announcement ADD COLUMN university_id bigint NULL;
            """
        ),
        migrations.AlterField(
            model_name='review',
            name='rating',
            field=models.IntegerField(choices=[(1, '1 Star'), (2, '2 Stars'), (3, '3 Stars'), (4, '4 Stars'), (5, '5 Stars')], validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(5)]),
        ),
    ]