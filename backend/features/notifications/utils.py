from .models import Notification

def create_notification(user_id, notif_type, content, actor_id=None,
                        actor_full_name='', conversation_id=None,
                        announcement_id=None, message_preview=''):
    Notification.objects.create(
        user_id=user_id,
        type=notif_type,
        content=content,
        actor_id=actor_id,
        actor_full_name=actor_full_name,
        conversation_id=conversation_id,
        announcement_id=announcement_id,
        message_preview=message_preview,
    )