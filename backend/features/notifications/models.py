from django.db import models


class Notification(models.Model):

    class Type(models.TextChoices):
        # messages
        NEW_MESSAGE       = 'new_message',        'New message'
        NEW_PHOTO_MESSAGE = 'new_photo_message',  'New photo message'
        # engagement on seller's post
        NEW_REVIEW        = 'new_review',         'New review'
        NEW_FAVORITE      = 'new_favorite',       'Added to favorites'
        NEW_COMMENT       = 'new_comment',        'New comment'
        COMMENT_REPLY     = 'comment_reply',      'Reply to your comment'

    user_id = models.UUIDField(db_index=True)

    type = models.CharField(max_length=30, choices=Type.choices)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    content = models.TextField()

    # deep-link data so the app knows where to navigate
    announcement_id = models.IntegerField(null=True, blank=True)
    conversation_id = models.IntegerField(null=True, blank=True)
    comment_id      = models.IntegerField(null=True, blank=True)

    # inline preview for messages
    message_preview   = models.TextField(blank=True)
    message_image_url = models.URLField(blank=True, null=True)

    # who triggered the notification
    actor_id        = models.UUIDField(null=True, blank=True)
    actor_full_name = models.CharField(max_length=255, blank=True)

    class Meta:
        db_table = 'notification'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user_id', '-created_at']),
            models.Index(fields=['user_id', 'is_read']),
        ]

    def __str__(self):
        return f"[{self.type}] → user {self.user_id}: {self.content[:60]}"