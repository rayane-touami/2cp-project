#!/usr/bin/env bash
set -e
pip install -r requirements.txt
mkdir -p static
python manage.py collectstatic --no-input
python manage.py migrate
python manage.py loaddata categories.json || echo "Fixture already loaded, skipping"