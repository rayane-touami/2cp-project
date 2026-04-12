from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.tokens import RefreshToken
from features.universities.models import University
from .models import Student

User = get_user_model()


class UniversityListView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        universities = University.objects.all().order_by('name')
        data = [
            {
                'id':   str(u.id),
                'name': u.name,
            }
            for u in universities
        ]
        return Response(data)


class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        email         = request.data.get('email')
        password      = request.data.get('password')
        full_name     = request.data.get('full_name')
        phone         = request.data.get('phone', None)
        university_id = request.data.get('university_id', None)

        if not email or not password or not full_name:
            return Response(
                {'error': 'email, password et full_name sont obligatoires'},
                status=400
            )

        if User.objects.filter(email=email).exists():
            return Response({'error': 'Email existe déjà'}, status=400)

        university = None
        if university_id:
            try:
                university = University.objects.get(id=university_id)
            except University.DoesNotExist:
                return Response({'error': 'Université introuvable'}, status=400)

        user = User.objects.create_user(
            email=email,
            password=password,
            full_name=full_name,
            phone=phone,
        )

        Student.objects.create(
            user=user,
            university=university,
        )

        refresh = RefreshToken.for_user(user)
        return Response({
            'access':  str(refresh.access_token),
            'refresh': str(refresh),
        }, status=201)


class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data.get('refresh')
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({'message': 'Déconnecté'})
        except Exception:
            return Response({'error': 'Token invalide'}, status=400)


class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        data = {
            'id':        str(user.id),
            'email':     user.email,
            'full_name': user.full_name,
            'phone':     user.phone,
        }

        if hasattr(user, 'student_profile'):
            student = user.student_profile
            data['university'] = {
                'id':   str(student.university.id),
                'name': student.university.name,
            } if student.university else None

        return Response(data)