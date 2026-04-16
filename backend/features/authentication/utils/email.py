from django.core.mail import send_mail
from django.conf import settings


def send_verification_code(to_email: str, code: str, purpose: str):
    """
    Envoie un code à 6 chiffres par email.
    `purpose` : 'register' | 'reset_password'
    """
    if purpose == 'register':
        subject = "Confirme ton inscription"
        body = (
            f"Bonjour,\n\n"
            f"Ton code de confirmation est : {code}\n\n"
            f"Ce code expire dans 15 minutes.\n\n"
            f"Si tu n'as pas créé de compte, ignore ce message."
        )
    else:
        subject = "Réinitialisation de ton mot de passe"
        body = (
            f"Bonjour,\n\n"
            f"Ton code de réinitialisation est : {code}\n\n"
            f"Ce code expire dans 15 minutes.\n\n"
            f"Si tu n'es pas à l'origine de cette demande, ignore ce message."
        )

    send_mail(
        subject=subject,
        message=body,
        from_email=settings.DEFAULT_FROM_EMAIL,
        recipient_list=[to_email],
        fail_silently=False,
    )