#!/usr/bin/env bash
set -e
pip install -r requirements.txt
mkdir -p static
python manage.py collectstatic --no-input
python manage.py migrate --fake-initial
python manage.py loaddata features/universities/fixtures/universities.json || echo "Universities already loaded, skipping"
python manage.py loaddata features/announcements/fixtures/categories.json || echo "Categories already loaded, skipping"