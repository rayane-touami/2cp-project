from rest_framework.permissions import BasePermission, SAFE_METHODS
from features.authentication.models import Student


class IsSellerOrReadOnly(BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in SAFE_METHODS:
            return True
        try:
            student = Student.objects.get(user=request.user)
            return obj.seller == student
        except Student.DoesNotExist:
            return False