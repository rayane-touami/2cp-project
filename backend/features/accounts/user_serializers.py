from rest_framework import serializers
from django.contrib.auth import get_user_model

User = get_user_model()


class UserUpdateSerializer(serializers.ModelSerializer):
    current_password = serializers.CharField(write_only=True, required=False)
    new_password = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = User
        fields = ['full_name', 'current_password', 'new_password']

    def validate(self, data):
        user = self.context['request'].user
        if data.get('new_password'):
            if not data.get('current_password'):
                raise serializers.ValidationError({
                    'current_password': 'Current password is required.'
                })
            if not user.check_password(data['current_password']):
                raise serializers.ValidationError({
                    'current_password': 'Current password is incorrect.'
                })
            if len(data['new_password']) < 8:
                raise serializers.ValidationError({
                    'new_password': 'Must be at least 8 characters.'
                })
        return data

    def update(self, instance, validated_data):
        validated_data.pop('current_password', None)
        new_password = validated_data.pop('new_password', None)
        instance.full_name = validated_data.get('full_name', instance.full_name)
        if new_password:
            instance.set_password(new_password)
        instance.save()
        return instance