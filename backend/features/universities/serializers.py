from rest_framework import serializers
from .models import University


class UniversitySerializer(serializers.ModelSerializer):
    logo_url = serializers.SerializerMethodField()

    class Meta:
        model = University
        fields = ['id', 'name', 'location', 'domain', 'logo_url', 'latitude', 'longitude']

    def get_logo_url(self, obj):
        if obj.logo:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.logo.url)
            return obj.logo.url
        return None