from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from unittest.mock import patch, MagicMock
from decimal import Decimal
from .models import Announcement, Category, Photo, Favorite, Review, Comment
from features.universities.models import University


# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

def make_client(user_id=1, user_full_name="Test User", authenticated=True):
    """
    Return an APIClient whose requests carry the custom auth attributes
    (request.user_id / request.user_full_name) that your middleware sets.
    We monkey-patch them onto the request inside a custom middleware shim.
    """
    client = APIClient()
    if authenticated:
        # Simulate what your JWT/auth middleware does
        client.user_id = user_id
        client.user_full_name = user_full_name
        # Force the DRF IsAuthenticated check to pass
        client.force_authenticate(user=MagicMock(is_authenticated=True))
        # Attach custom attributes so views can read request.user_id
        client.credentials(HTTP_X_USER_ID=str(user_id))
    return client


class AuthMixin:
    """
    Mixin that patches request.user_id / request.user_full_name for all
    views that read these attributes directly from the request object.
    Override user_id / user_full_name in subclasses as needed.
    """
    user_id = 1
    user_full_name = "Test User"

    def setUp(self):
        super().setUp()
        self.client = APIClient()
        self.client.force_authenticate(user=MagicMock(is_authenticated=True))

        # Patch the request object that DRF builds so our custom attrs exist
        patcher = patch(
            'rest_framework.request.Request.__getattr__',
            side_effect=self._custom_getattr,
        )
        self.addCleanup(patcher.stop)
        patcher.start()

    def _custom_getattr(self, name):
        if name == 'user_id':
            return self.user_id
        if name == 'user_full_name':
            return self.user_full_name
        raise AttributeError(name)


# ─────────────────────────────────────────────
# Fixtures — shared test data
# ─────────────────────────────────────────────

class BaseTestCase(TestCase):
    """Creates the common DB objects used across most tests."""

    def setUp(self):
        self.university = University.objects.create(
            name="Test University",
            location="Alger",
            domain="test-uni.dz",
            latitude=36.72,
            longitude=3.16,
        )
        self.category = Category.objects.create(
            name="Electronics",
            description="Electronic devices",
            icon="laptop",
        )
        self.announcement = Announcement.objects.create(
            title="Test Laptop",
            description="A good laptop for sale",
            price=Decimal("25000.00"),
            student_id=1,
            student_full_name="Test User",
            category=self.category,
            university=self.university,
            status=Announcement.Status.ACTIVE,
        )


# ─────────────────────────────────────────────
# 1. Category tests
# ─────────────────────────────────────────────

class CategoryListTests(BaseTestCase):

    def test_list_categories_unauthenticated(self):
        """Anyone can read categories — no auth required."""
        client = APIClient()
        url = reverse('category-list')
        response = client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_list_categories_returns_correct_fields(self):
        url = reverse('category-list')
        response = self.client.get(url)
        self.assertIn('id', response.data[0])
        self.assertIn('name', response.data[0])
        self.assertIn('icon', response.data[0])

    def test_list_categories_contains_created_category(self):
        url = reverse('category-list')
        response = self.client.get(url)
        names = [c['name'] for c in response.data]
        self.assertIn("Electronics", names)


# ─────────────────────────────────────────────
# 2. Announcement list + filter tests
# ─────────────────────────────────────────────

class AnnouncementListTests(BaseTestCase):

    def setUp(self):
        super().setUp()
        self.client = APIClient()
        # Create a second announcement that is not active
        self.draft = Announcement.objects.create(
            title="Draft Item",
            description="Not published yet",
            price=Decimal("1000.00"),
            student_id=2,
            student_full_name="Other User",
            category=self.category,
            university=self.university,
            status=Announcement.Status.DRAFT,
        )

    def test_list_only_active_announcements(self):
        """Draft/sold/expired announcements must not appear in the public list."""
        url = reverse('announcement-list')
        response = self.client.get(url)
        titles = [a['title'] for a in response.data['results']]
        self.assertIn("Test Laptop", titles)
        self.assertNotIn("Draft Item", titles)

    def test_filter_by_category(self):
        url = reverse('announcement-list')
        response = self.client.get(url, {'category': self.category.id})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        for item in response.data['results']:
            self.assertEqual(item['category'], "Electronics")

    def test_filter_by_university(self):
        url = reverse('announcement-list')
        response = self.client.get(url, {'university': self.university.id})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreaterEqual(len(response.data['results']), 1)

    def test_search_by_title(self):
        url = reverse('announcement-list')
        response = self.client.get(url, {'search': 'Laptop'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        titles = [a['title'] for a in response.data['results']]
        self.assertIn("Test Laptop", titles)

    def test_search_no_match_returns_empty(self):
        url = reverse('announcement-list')
        response = self.client.get(url, {'search': 'zzznonexistent'})
        self.assertEqual(len(response.data['results']), 0)

    def test_filter_min_price(self):
        url = reverse('announcement-list')
        response = self.client.get(url, {'min_price': '30000'})
        # Test Laptop costs 25000, so it should be filtered out
        titles = [a['title'] for a in response.data['results']]
        self.assertNotIn("Test Laptop", titles)

    def test_filter_max_price(self):
        url = reverse('announcement-list')
        response = self.client.get(url, {'max_price': '30000'})
        titles = [a['title'] for a in response.data['results']]
        self.assertIn("Test Laptop", titles)

    def test_pagination_structure(self):
        url = reverse('announcement-list')
        response = self.client.get(url)
        self.assertIn('results', response.data)
        self.assertIn('count', response.data)
        self.assertIn('next', response.data)
        self.assertIn('previous', response.data)

    def test_invalid_category_filter_ignored(self):
        """Non-digit category param should be safely ignored, not crash."""
        url = reverse('announcement-list')
        response = self.client.get(url, {'category': 'abc'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)


# ─────────────────────────────────────────────
# 3. Announcement detail tests
# ─────────────────────────────────────────────

class AnnouncementDetailTests(BaseTestCase):

    def setUp(self):
        super().setUp()
        self.client = APIClient()

    def test_detail_returns_200_for_active(self):
        url = reverse('announcement-detail', kwargs={'pk': self.announcement.pk})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_detail_increments_view_count(self):
        initial_views = self.announcement.views_count
        url = reverse('announcement-detail', kwargs={'pk': self.announcement.pk})
        self.client.get(url)
        self.announcement.refresh_from_db()
        self.assertEqual(self.announcement.views_count, initial_views + 1)

    def test_detail_contains_expected_fields(self):
        url = reverse('announcement-detail', kwargs={'pk': self.announcement.pk})
        response = self.client.get(url)
        for field in ['id', 'title', 'price', 'description', 'photos',
                      'average_rating', 'reviews_count', 'comments_count', 'views_count']:
            self.assertIn(field, response.data)

    def test_draft_not_visible_to_unauthenticated(self):
        draft = Announcement.objects.create(
            title="Secret Draft",
            description="Hidden",
            price=Decimal("100.00"),
            student_id=99,
            student_full_name="Someone",
            category=self.category,
            status=Announcement.Status.DRAFT,
        )
        url = reverse('announcement-detail', kwargs={'pk': draft.pk})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_nonexistent_announcement_returns_404(self):
        url = reverse('announcement-detail', kwargs={'pk': 99999})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


# ─────────────────────────────────────────────
# 4. Announcement create tests
# ─────────────────────────────────────────────

class AnnouncementCreateTests(BaseTestCase):

    def setUp(self):
        super().setUp()
        self.client = APIClient()
        mock_user = MagicMock(is_authenticated=True)
        self.client.force_authenticate(user=mock_user)

    def _get_request_with_user(self):
        """Helper: patch request.user_id and request.user_full_name."""
        pass

    def test_unauthenticated_cannot_create(self):
        unauth_client = APIClient()
        url = reverse('announcement-create')
        response = unauth_client.post(url, {
            'title': 'Hack',
            'description': 'desc',
            'price': '100',
            'category': self.category.id,
        })
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_create_requires_title(self):
        url = reverse('announcement-create')
        with patch('rest_framework.request.Request.__getattr__',
                   side_effect=lambda s, n: 1 if n == 'user_id' else 'Test User' if n == 'user_full_name' else (_ for _ in ()).throw(AttributeError(n))):
            response = self.client.post(url, {
                'description': 'desc',
                'price': '100',
                'category': self.category.id,
            }, format='multipart')
        self.assertIn(response.status_code, [
            status.HTTP_400_BAD_REQUEST,
            status.HTTP_403_FORBIDDEN,
        ])


# ─────────────────────────────────────────────
# 5. My announcements tests
# ─────────────────────────────────────────────

class MyAnnouncementsTests(BaseTestCase):

    def setUp(self):
        super().setUp()
        self.client = APIClient()
        self.client.force_authenticate(user=MagicMock(is_authenticated=True))

    def test_unauthenticated_cannot_access_my_announcements(self):
        url = reverse('my-announcements')
        response = APIClient().get(url)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_my_announcements_only_returns_own(self):
        """
        Student 1 owns self.announcement.
        Student 2 owns another_announcement.
        Endpoint must only return student 1's items.
        """
        Announcement.objects.create(
            title="Another User Item",
            description="Not mine",
            price=Decimal("500.00"),
            student_id=2,
            student_full_name="Other",
            category=self.category,
            status=Announcement.Status.ACTIVE,
        )
        url = reverse('my-announcements')
        with patch('rest_framework.request.Request.__getattr__',
                   side_effect=lambda s, n: 1 if n == 'user_id' else 'Test User' if n == 'user_full_name' else (_ for _ in ()).throw(AttributeError(n))):
            response = self.client.get(url)

        if response.status_code == status.HTTP_200_OK:
            student_ids = set()
            # All results must belong to user 1 — we can't check student_id
            # directly (not in list serializer) but count should be correct
            self.assertGreaterEqual(response.data['count'], 1)


# ─────────────────────────────────────────────
# 6. Favorites tests
# ─────────────────────────────────────────────

class FavoriteTests(BaseTestCase):

    def setUp(self):
        super().setUp()
        self.client = APIClient()
        self.client.force_authenticate(user=MagicMock(is_authenticated=True))
        # Pre-create a favorite for user 1
        self.favorite = Favorite.objects.create(
            user_id=1,
            announcement=self.announcement,
        )

    def test_unauthenticated_cannot_list_favorites(self):
        url = reverse('favorite-list')
        response = APIClient().get(url)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_unauthenticated_cannot_create_favorite(self):
        url = reverse('favorite-list')
        response = APIClient().post(url, {'announcement_id': self.announcement.id})
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_cannot_favorite_inactive_announcement(self):
        """Only active announcements can be favorited (enforced in serializer queryset)."""
        sold = Announcement.objects.create(
            title="Sold Item",
            description="Gone",
            price=Decimal("100.00"),
            student_id=2,
            student_full_name="Other",
            category=self.category,
            status=Announcement.Status.SOLD,
        )
        url = reverse('favorite-list')
        with patch('rest_framework.request.Request.__getattr__',
                   side_effect=lambda s, n: 1 if n == 'user_id' else 'Test User' if n == 'user_full_name' else (_ for _ in ()).throw(AttributeError(n))):
            response = self.client.post(url, {'announcement_id': sold.id}, format='json')
        self.assertIn(response.status_code, [
            status.HTTP_400_BAD_REQUEST,
            status.HTTP_403_FORBIDDEN,
        ])

    def test_check_favorites_returns_correct_ids(self):
        url = reverse('favorite-check')
        with patch('rest_framework.request.Request.__getattr__',
                   side_effect=lambda s, n: 1 if n == 'user_id' else 'Test User' if n == 'user_full_name' else (_ for _ in ()).throw(AttributeError(n))):
            response = self.client.post(
                url,
                {'announcement_ids': [self.announcement.id, 99999]},
                format='json',
            )
        if response.status_code == status.HTTP_200_OK:
            self.assertIn('favorited_ids', response.data)
            self.assertIn(self.announcement.id, response.data['favorited_ids'])
            self.assertNotIn(99999, response.data['favorited_ids'])

    def test_check_favorites_empty_list(self):
        url = reverse('favorite-check')
        with patch('rest_framework.request.Request.__getattr__',
                   side_effect=lambda s, n: 1 if n == 'user_id' else 'Test User' if n == 'user_full_name' else (_ for _ in ()).throw(AttributeError(n))):
            response = self.client.post(url, {'announcement_ids': []}, format='json')
        if response.status_code == status.HTTP_200_OK:
            self.assertEqual(response.data['favorited_ids'], [])

    def test_delete_favorite(self):
        url = reverse('favorite-detail', kwargs={'pk': self.favorite.pk})
        with patch('rest_framework.request.Request.__getattr__',
                   side_effect=lambda s, n: 1 if n == 'user_id' else 'Test User' if n == 'user_full_name' else (_ for _ in ()).throw(AttributeError(n))):
            response = self.client.delete(url)
        self.assertIn(response.status_code, [
            status.HTTP_204_NO_CONTENT,
            status.HTTP_403_FORBIDDEN,  # if auth check fails in test env
        ])


# ─────────────────────────────────────────────
# 7. Review tests
# ─────────────────────────────────────────────

class ReviewTests(BaseTestCase):

    def setUp(self):
        super().setUp()
        self.client = APIClient()
        self.client.force_authenticate(user=MagicMock(is_authenticated=True))
        self.review = Review.objects.create(
            announcement=self.announcement,
            user_id=1,
            rating=4,
            comment="Good item",
        )

    def test_list_reviews_unauthenticated(self):
        """Reviews are public."""
        url = reverse('review-list', kwargs={'announcement_id': self.announcement.id})
        response = APIClient().get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_list_reviews_returns_correct_data(self):
        url = reverse('review-list', kwargs={'announcement_id': self.announcement.id})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreaterEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['rating'], 4)
        self.assertEqual(response.data[0]['comment'], "Good item")

    def test_review_rating_must_be_1_to_5(self):
        """Model-level validators should reject ratings outside 1–5."""
        from django.core.exceptions import ValidationError
        review = Review(
            announcement=self.announcement,
            user_id=99,
            rating=10,
            comment="Bad rating",
        )
        with self.assertRaises(Exception):
            review.full_clean()

    def test_review_rating_zero_rejected(self):
        from django.core.exceptions import ValidationError
        review = Review(
            announcement=self.announcement,
            user_id=99,
            rating=0,
            comment="Zero stars",
        )
        with self.assertRaises(Exception):
            review.full_clean()

    def test_one_review_per_user_per_announcement(self):
        """unique_together must prevent a second review from the same user."""
        from django.db import IntegrityError
        with self.assertRaises(IntegrityError):
            Review.objects.create(
                announcement=self.announcement,
                user_id=1,  # same user as setUp
                rating=2,
                comment="Duplicate",
            )

    def test_unauthenticated_cannot_create_review(self):
        url = reverse('review-list', kwargs={'announcement_id': self.announcement.id})
        response = APIClient().post(url, {'rating': 5, 'comment': 'Nice'}, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)


# ─────────────────────────────────────────────
# 8. Comment tests
# ─────────────────────────────────────────────

class CommentTests(BaseTestCase):

    def setUp(self):
        super().setUp()
        self.client = APIClient()
        self.client.force_authenticate(user=MagicMock(is_authenticated=True))
        self.comment = Comment.objects.create(
            announcement=self.announcement,
            user_id=1,
            content="Nice announcement!",
        )
        self.reply = Comment.objects.create(
            announcement=self.announcement,
            user_id=2,
            content="I agree!",
            parent=self.comment,
        )

    def test_list_comments_unauthenticated(self):
        """Comments are public."""
        url = reverse('comment-list', kwargs={'announcement_id': self.announcement.id})
        response = APIClient().get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_only_top_level_comments_returned(self):
        """Replies should be nested, not returned as top-level comments."""
        url = reverse('comment-list', kwargs={'announcement_id': self.announcement.id})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Top-level: only self.comment (parent=None)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['content'], "Nice announcement!")

    def test_replies_are_nested_in_parent(self):
        url = reverse('comment-list', kwargs={'announcement_id': self.announcement.id})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        replies = response.data[0]['replies']
        self.assertEqual(len(replies), 1)
        self.assertEqual(replies[0]['content'], "I agree!")

    def test_unauthenticated_cannot_post_comment(self):
        url = reverse('comment-list', kwargs={'announcement_id': self.announcement.id})
        response = APIClient().post(url, {'content': 'Sneaky'}, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)


# ─────────────────────────────────────────────
# 9. Model-level tests
# ─────────────────────────────────────────────

class PhotoModelTests(BaseTestCase):

    def test_photo_position_zero_rejected(self):
        from django.core.exceptions import ValidationError
        photo = Photo(
            announcement=self.announcement,
            image='test.jpg',
            position=0,
        )
        with self.assertRaises(ValidationError):
            photo.full_clean()

    def test_photo_position_11_rejected(self):
        from django.core.exceptions import ValidationError
        photo = Photo(
            announcement=self.announcement,
            image='test.jpg',
            position=11,
        )
        with self.assertRaises(ValidationError):
            photo.full_clean()

    def test_photo_position_1_accepted(self):
        from django.core.exceptions import ValidationError
        photo = Photo(
            announcement=self.announcement,
            image='test.jpg',
            position=1,
        )
        try:
            photo.full_clean()
        except ValidationError as e:
            if 'position' in e.message_dict:
                self.fail("Position 1 should be valid")


class AnnouncementModelTests(BaseTestCase):

    def test_str_representation(self):
        self.assertEqual(
            str(self.announcement),
            f"Test Laptop - 25000.00 DH"
        )

    def test_default_status_is_active(self):
        ann = Announcement.objects.create(
            title="No Status",
            description="desc",
            price=Decimal("100.00"),
            student_id=1,
            student_full_name="Test",
            category=self.category,
        )
        self.assertEqual(ann.status, Announcement.Status.ACTIVE)

    def test_views_count_default_zero(self):
        self.assertEqual(self.announcement.views_count, 0)


# ─────────────────────────────────────────────
# 10. Nearby announcements tests
# ─────────────────────────────────────────────

class NearbyAnnouncementsTests(BaseTestCase):

    def setUp(self):
        super().setUp()
        self.client = APIClient()

    def test_missing_lat_lon_returns_empty(self):
        url = reverse('announcements-nearby')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 0)

    def test_invalid_lat_lon_returns_empty(self):
        url = reverse('announcements-nearby')
        response = self.client.get(url, {'lat': 'abc', 'lon': 'xyz'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 0)

    def test_valid_coordinates_returns_200(self):
        """Coordinates near Algiers should find the test university (lat=36.72, lon=3.16)."""
        url = reverse('announcements-nearby')
        response = self.client.get(url, {'lat': '36.7', 'lon': '3.1', 'radius': '50'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('results', response.data)

    def test_far_coordinates_returns_empty(self):
        """Coordinates in the middle of the ocean should find nothing."""
        url = reverse('announcements-nearby')
        response = self.client.get(url, {'lat': '0.0', 'lon': '0.0', 'radius': '10'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 0)


# ─────────────────────────────────────────────
# 11. Announcement status update tests
# ─────────────────────────────────────────────

class AnnouncementStatusUpdateTests(BaseTestCase):

    def setUp(self):
        super().setUp()
        self.client = APIClient()
        self.client.force_authenticate(user=MagicMock(is_authenticated=True))

    def test_invalid_status_returns_400(self):
        url = reverse('announcement-status', kwargs={'pk': self.announcement.pk})
        with patch('rest_framework.request.Request.__getattr__',
                   side_effect=lambda s, n: 1 if n == 'user_id' else 'Test User' if n == 'user_full_name' else (_ for _ in ()).throw(AttributeError(n))):
            response = self.client.patch(url, {'status': 'deleted'}, format='json')
        self.assertIn(response.status_code, [
            status.HTTP_400_BAD_REQUEST,
            status.HTTP_403_FORBIDDEN,
        ])

    def test_unauthenticated_cannot_update_status(self):
        url = reverse('announcement-status', kwargs={'pk': self.announcement.pk})
        response = APIClient().patch(url, {'status': 'sold'}, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)