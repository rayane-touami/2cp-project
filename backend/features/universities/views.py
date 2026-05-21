from rest_framework import generics
from rest_framework.permissions import AllowAny
from .models import University
from .serializers import UniversitySerializer


class UniversityListView(generics.ListAPIView):
    serializer_class = UniversitySerializer
    permission_classes = [AllowAny]  # needed so unauthenticated users can
                                     # pick a university during registration

    def get_queryset(self):
        queryset = University.objects.all()
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.filter(name__icontains=search)
        return queryset