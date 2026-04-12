from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from .models import Notification
from .serializers import NotificationSerializer


class NotificationListAPIView(generics.ListAPIView):
    """
    GET /notifications/
    Returns all notifications for the logged-in user, newest first.
    Supports ?unread_only=true to filter unread ones.
    """
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        qs = Notification.objects.filter(user_id=self.request.user.id)
        if self.request.query_params.get('unread_only') == 'true':
            qs = qs.filter(is_read=False)
        return qs


class NotificationMarkReadAPIView(APIView):
    """
    PATCH /notifications/<pk>/read/
    Marks a single notification as read.
    """
    permission_classes = [IsAuthenticated]

    def patch(self, request, pk):
        try:
            notif = Notification.objects.get(pk=pk, user_id=request.user.id)
        except Notification.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        notif.is_read = True
        notif.save(update_fields=['is_read'])
        return Response({'status': 'read'})


class NotificationMarkAllReadAPIView(APIView):
    """
    PATCH /notifications/read-all/
    Marks every unread notification as read for the logged-in user.
    """
    permission_classes = [IsAuthenticated]

    def patch(self, request):
        Notification.objects.filter(
            user_id=request.user.id,
            is_read=False
        ).update(is_read=True)
        return Response({'status': 'all read'})


class NotificationUnreadCountAPIView(APIView):
    """
    GET /notifications/unread-count/
    Returns the unread count — used by the app to show the bell badge.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        count = Notification.objects.filter(
            user_id=request.user.id,
            is_read=False
        ).count()
        return Response({'unread_count': count})