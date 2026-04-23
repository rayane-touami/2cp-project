from rest_framework import generics
from .models import University
from .serializers import UniversitySerializer

class UniversityListView(generics.ListAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer
    permission_classes = []