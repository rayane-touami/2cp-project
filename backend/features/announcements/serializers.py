from rest_framework import serializers
from django.core.files.images import get_image_dimensions
from .models import Announcement, Category, Photo, Favorite

class CategorySerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Category
        fields = ['id', 'name', 'description', 'icon']

class PhotoSerializer(serializers.ModelSerializer):
        url = serializers.SerializerMethodField()
    
    class Meta:
        model = Photo
        fields = ['id', 'url', 'position']
    
    def get_url(self, obj):
        if obj.image:
            return obj.image.url
        return None

class AnnouncementListSerializer(serializers.ModelSerializer):
    photo = serializers.SerializerMethodField()
    seller = serializers.CharField(source='student_full_name')
    category = serializers.CharField(source='category.name')
    price = serializers.DecimalField(max_digits=10, decimal_places=2, coerce_to_string=False)
    is_favorited = serializers.SerializerMethodField() 
    
    class Meta:
        model = Announcement
        fields = [
            'id', 'title', 'price', 'photo', 
            'seller', 'category', 'created_at'
            'is_favorited'
        ]

    def get_is_favorited(self, obj):  
        request = self.context.get('request')
        if request and hasattr(request, 'user_id'):
            return obj.favorited_by.filter(user_id=request.user_id).exists()
        return False

    
    def get_photo(self, obj):
        first_photo = obj.photos.first()
        if first_photo and first_photo.image:
            return first_photo.image.url
        return None

class AnnouncementDetailSerializer(serializers.ModelSerializer):
    photos = PhotoSerializer(many=True, read_only=True)
    seller = serializers.CharField(source='student_full_name')
    category = CategorySerializer(read_only=True)
    category_id = serializers.PrimaryKeyRelatedField(
        queryset=Category.objects.all(), 
        source='category',
        write_only=True
    )
    price = serializers.DecimalField(max_digits=10, decimal_places=2, coerce_to_string=False)
    
    class Meta:
        model = Announcement
        fields = [
            'id', 'title', 'description', 'price', 
            'photos', 'seller', 'category', 'category_id', 
            'location', 'status', 'created_at', 'updated_at'
        ]
        read_only_fields = ['student_id', 'student_full_name', 'status', 'created_at', 'updated_at']

class AnnouncementCreateSerializer(serializers.ModelSerializer):
    photos = serializers.ListField(
        child=serializers.ImageField(
            max_length=100,
            allow_empty_file=False,
            use_url=False
        ),
        write_only=True,
        required=False,
        min_length=0,
        max_length=5
    )
    price = serializers.DecimalField(max_digits=10, decimal_places=2, min_value=0)
    
    class Meta:
        model = Announcement
        fields = [
            'title', 'description', 'price', 
            'category', 'location', 'photos'
        ]
    
    def validate_photos(self, value):
        if len(value) > 5:
            raise serializers.ValidationError("Maximum 5 photos allowed")
        
     
        for image in value:
            if image.size > 30 * 1024 * 1024:  # 30mega max
                raise serializers.ValidationError(f"Image {image.name} is too large. Max size is 30MB")
          
            width, height = get_image_dimensions(image)
            if width > 4000 or height > 4000:
                raise serializers.ValidationError(f"Image {image.name} dimensions are too large")
        
        return value
    
    def validate_title(self, value):
        if not value or not value.strip():
            raise serializers.ValidationError("Title cannot be empty")
        return value.strip()
    
    def create(self, validated_data):
        photos_data = validated_data.pop('photos', [])
        
       
        request = self.context.get('request')
        
        student_id = getattr(request, 'user_id', None)
        student_full_name = getattr(request, 'user_full_name', 'Unknown User')
        
        if not student_id:
            raise serializers.ValidationError({"error": "User authentication required"})
        
        announcement = Announcement.objects.create(
            student_id=student_id,
            student_full_name=student_full_name,
            **validated_data
        )
        
        
        for position, photo_file in enumerate(photos_data, start=1):
            Photo.objects.create(
                announcement=announcement,
                image=photo_file,
                position=position
            )

class FavoriteSerializer(serializers.ModelSerializer):
    announcement = AnnouncementListSerializer(read_only=True)
    announcement_id = serializers.PrimaryKeyRelatedField(
        queryset=Announcement.objects.filter(status='active'),
        write_only=True,
        source='announcement'
    )
    
    class Meta:
        model = Favorite
        fields = ['id', 'announcement', 'announcement_id', 'created_at']
        read_only_fields = ['user_id']
    
    def create(self, validated_data):
        request = self.context.get('request')
        validated_data['user_id'] = request.user_id
        return super().create(validated_data)
        
