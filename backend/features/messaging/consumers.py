
import json
import asyncio
import redis.asyncio as aioredis
from channels.generic.websocket import AsyncWebsocketConsumer
from firebase_admin import messaging
from .models import Message, Conversation, UserDevice

REDIS_URL = "redis://127.0.0.1:6379"

def send_push_notification(token, title, body):
    try:
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            token=token,
        )
        messaging.send(message)
    except Exception as e:
        print(f"Notification error: {e}")

class ChatConsumer(AsyncWebsocketConsumer):

    async def connect(self):
        if not self.scope["user"].is_authenticated:
            await self.close()
            return

        self.redis = aioredis.from_url(REDIS_URL)
        await self.redis.set(f"user_{self.scope['user'].id}_online", "true")

        self.conversation_id = self.scope['url_route']['kwargs']['conversation_id']
        self.room_group_name = f'chat_{self.conversation_id}'

        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )
        await self.accept()

    async def disconnect(self, close_code):
        if hasattr(self, 'redis'):
            await self.redis.delete(f"user_{self.scope['user'].id}_online")
            await self.redis.aclose()

        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']

        await Message.objects.acreate(
            conversation_id=self.conversation_id,
            sender=self.scope['user'],
            content=message
        )

        await self.channel_layer.group_send(
            self.room_group_name,
            {
                "type": "chat.message",
                "message": message,
                "sender_email": self.scope['user'].email,
            }
        )

        await self.notify_receiver(message)

    async def chat_message(self, event):
        await self.send(text_data=json.dumps({
            "message": event["message"],
            "sender_email": event["sender_email"],
        }))

    async def notify_receiver(self, message):
        try:
            conversation = await Conversation.objects.aget(
                id=self.conversation_id
            )

            sender = self.scope['user']

            if sender.id == conversation.buyer_id:
                receiver_id = conversation.seller_id
            else:
                receiver_id = conversation.buyer_id

            r = aioredis.from_url(REDIS_URL)
            is_online = await r.get(f"user_{receiver_id}_online")
            await r.aclose()

            if not is_online:
                try:
                    device = await UserDevice.objects.aget(user_id=receiver_id)
                    await asyncio.to_thread(
                        send_push_notification,
                        device.device_token,
                        f"New message from {sender.email}",
                        message
                    )
                except UserDevice.DoesNotExist:
                    pass
        except Exception as e:
            print(f"notify_receiver error: {e}")