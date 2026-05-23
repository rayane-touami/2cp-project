import sib_api_v3_sdk
from sib_api_v3_sdk.rest import ApiException
from django.conf import settings


def send_verification_code(to_email: str, code: str, purpose: str):
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

    configuration = sib_api_v3_sdk.Configuration()
    configuration.api_key['api-key'] = settings.BREVO_API_KEY

    api_instance = sib_api_v3_sdk.TransactionalEmailsApi(
        sib_api_v3_sdk.ApiClient(configuration)
    )

    send_smtp_email = sib_api_v3_sdk.SendSmtpEmail(
        to=[{"email": to_email}],
        sender={"email": "noreply@2cp-project.com", "name": "2CP Project"},
        subject=subject,
        html_content=html
    )

    api_instance.send_transac_email(send_smtp_email)