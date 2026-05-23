import resend
from django.conf import settings


def send_verification_code(to_email: str, code: str, purpose: str):
    resend.api_key = settings.RESEND_API_KEY

    if purpose == 'register':
        subject = "Confirme ton inscription"
        html = (
            f"<p>Bonjour,</p>"
            f"<p>Ton code de confirmation est : <strong>{code}</strong></p>"
            f"<p>Ce code expire dans 15 minutes.</p>"
            f"<p>Si tu n'as pas créé de compte, ignore ce message.</p>"
        )
    else:
        subject = "Réinitialisation de ton mot de passe"
        html = (
            f"<p>Bonjour,</p>"
            f"<p>Ton code de réinitialisation est : <strong>{code}</strong></p>"
            f"<p>Ce code expire dans 15 minutes.</p>"
            f"<p>Si tu n'es pas à l'origine de cette demande, ignore ce message.</p>"
        )

    resend.Emails.send({
        "from": "onboarding@resend.dev",
        "to": to_email,
        "subject": subject,
        "html": html,
    })