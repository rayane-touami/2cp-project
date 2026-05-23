#!/usr/bin/env bash
set -e
pip install -r requirements.txt
mkdir -p static
python manage.py collectstatic --no-input
python manage.py migrate --fake-initial
python manage.py fix_university_column
