from .models import Notification


def _actor_id(request):
    return request.user.id


def _actor_name(request) -> str:
    return getattr(request.user, 'full_name', '')


def notify_new_message(request, recipient_id, conversation_id, message_text='', image_url=None):
    is_photo = bool(image_url)
    Notification.objects.create(
        user_id=recipient_id,
        type=Notification.Type.NEW_PHOTO_MESSAGE if is_photo else Notification.Type.NEW_MESSAGE,
        content=f"{_actor_name(request)} sent you a photo" if is_photo else f"{_actor_name(request)}: {message_text[:80]}",
        conversation_id=conversation_id,
        message_preview=message_text,
        message_image_url=image_url,
        actor_id=_actor_id(request),
        actor_full_name=_actor_name(request),
    )


def notify_new_review(request, recipient_id, announcement_id, rating):
    Notification.objects.create(
        user_id=recipient_id,
        type=Notification.Type.NEW_REVIEW,
        content=f"{_actor_name(request)} gave your listing {rating} star{'s' if rating != 1 else ''}",
        announcement_id=announcement_id,
        actor_id=_actor_id(request),
        actor_full_name=_actor_name(request),
    )


def notify_new_favorite(request, recipient_id, announcement_id, announcement_title):
    Notification.objects.create(
        user_id=recipient_id,
        type=Notification.Type.NEW_FAVORITE,
        content=f"{_actor_name(request)} added your listing \"{announcement_title}\" to favorites",
        announcement_id=announcement_id,
        actor_id=_actor_id(request),
        actor_full_name=_actor_name(request),
    )


def notify_new_comment(request, recipient_id, announcement_id, comment_id, comment_preview):
    Notification.objects.create(
        user_id=recipient_id,
        type=Notification.Type.NEW_COMMENT,
        content=f"{_actor_name(request)} commented: {comment_preview[:80]}",
        announcement_id=announcement_id,
        comment_id=comment_id,
        actor_id=_actor_id(request),
        actor_full_name=_actor_name(request),
    )


def notify_comment_reply(request, recipient_id, announcement_id, comment_id, reply_preview):
    Notification.objects.create(
        user_id=recipient_id,
        type=Notification.Type.COMMENT_REPLY,
        content=f"{_actor_name(request)} replied to your comment: {reply_preview[:80]}",
        announcement_id=announcement_id,
        comment_id=comment_id,
        actor_id=_actor_id(request),
        actor_full_name=_actor_name(request),
    )