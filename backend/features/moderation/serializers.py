from rest_framework import serializers
from features.announcements.models import Report


class ReportCreateSerializer(serializers.ModelSerializer):
    """
    Utilisé par le user Flutter pour soumettre un report.
    Il n'envoie que : announcement, reason, description (optionnel).
    reporter_id est injecté automatiquement depuis le token JWT.
    """

    class Meta:
        model  = Report
        fields = ['id', 'announcement', 'reason', 'description']

    def validate(self, attrs):
        # Vérifier que le user n'a pas déjà signalé cette annonce
        request      = self.context['request']
        reporter_id  = request.user.id
        announcement = attrs['announcement']

        if Report.objects.filter(reporter_id=reporter_id, announcement=announcement).exists():
            raise serializers.ValidationError(
                "Vous avez déjà signalé cette annonce."
            )
        return attrs

    def create(self, validated_data):
        # On injecte le reporter_id depuis le user authentifié
        validated_data['reporter_id'] = self.context['request'].user.id
        return super().create(validated_data)


class ReportAdminSerializer(serializers.ModelSerializer):
    """
    Utilisé par l'admin pour lister et gérer les reports.
    Inclut les infos complètes + le titre de l'annonce pour lisibilité.
    """
    announcement_title = serializers.CharField(
        source='announcement.title',
        read_only=True
    )
    announcement_status = serializers.CharField(
        source='announcement.status',
        read_only=True
    )

    class Meta:
        model  = Report
        fields = [
            'id',
            'announcement', 'announcement_title', 'announcement_status',
            'reporter_id',
            'reason', 'description',
            'status',
            'reviewed_by', 'reviewed_at',
            'created_at',
        ]
        read_only_fields = [
            'id', 'announcement', 'announcement_title', 'announcement_status',
            'reporter_id', 'reason', 'description',
            'reviewed_by', 'reviewed_at', 'created_at',
        ]