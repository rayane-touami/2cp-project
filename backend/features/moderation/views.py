from django.utils import timezone
from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from rest_framework.response import Response

from features.announcements.models import Announcement
from features.announcements.models import Report
from .serializers import ReportCreateSerializer, ReportAdminSerializer


class ReportCreateView(generics.CreateAPIView):
    serializer_class   = ReportCreateSerializer
    permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        report = serializer.save()
        return Response(
            {
                "detail": "Votre signalement a bien été envoyé.",
                "report_id": report.id
            },
            status=status.HTTP_201_CREATED
        )


class ReportListView(generics.ListAPIView):
    serializer_class   = ReportAdminSerializer
    permission_classes = [IsAdminUser]

    def get_queryset(self):
        queryset = Report.objects.select_related('announcement', 'reviewed_by').all()
        status_filter = self.request.query_params.get('status')
        if status_filter in [Report.Status.PENDING, Report.Status.RESOLVED, Report.Status.IGNORED]:
            queryset = queryset.filter(status=status_filter)
        return queryset


class ReportDetailView(generics.RetrieveUpdateAPIView):
    serializer_class   = ReportAdminSerializer
    permission_classes = [IsAdminUser]
    queryset           = Report.objects.select_related('announcement', 'reviewed_by').all()

    def update(self, request, *args, **kwargs):
        report     = self.get_object()
        new_status = request.data.get('status')

        if new_status not in [Report.Status.RESOLVED, Report.Status.IGNORED]:
            return Response(
                {"detail": "Status invalide. Utilisez 'resolved' ou 'ignored'."},
                status=status.HTTP_400_BAD_REQUEST
            )

        if report.status != Report.Status.PENDING:
            return Response(
                {"detail": f"Ce report a déjà été traité ({report.status})."},
                status=status.HTTP_400_BAD_REQUEST
            )

        report.status      = new_status
        report.reviewed_by = request.user
        report.reviewed_at = timezone.now()
        report.save()

        if new_status == Report.Status.RESOLVED:
            report.announcement.status = Announcement.Status.ARCHIVED
            report.announcement.save(update_fields=['status'])

        serializer = self.get_serializer(report)
        return Response(serializer.data, status=status.HTTP_200_OK)
