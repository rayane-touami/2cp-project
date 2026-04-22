from rest_framework import serializers
from .models import Review


class ReviewReadSerializer(serializers.ModelSerializer):
    reviewer_name = serializers.CharField(
        source='reviewer.user.full_name', read_only=True
    )

    class Meta:
        model = Review
        fields = ['id', 'reviewer_name', 'score', 'comment', 'created_at']


class ReviewWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = ['score', 'comment']

    def validate_score(self, value):
        if value < 1 or value > 5:
            raise serializers.ValidationError('Score must be between 1 and 5.')
        return value