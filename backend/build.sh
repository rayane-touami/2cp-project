#!/usr/bin/env bash
set -e
pip install -r requirements.txt
mkdir -p static
python manage.py collectstatic --no-input
python manage.py migrate --run-syncdb
python manage.py fix_university_column
python manage.py fix_profiles
python manage.py fix_student_ids || echo "fix_student_ids skipped"
python manage.py loaddata categories.json || echo "categories already loaded"
python manage.py loaddata universities.json || echo "universities already loaded"