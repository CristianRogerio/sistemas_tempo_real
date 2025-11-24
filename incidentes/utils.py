import requests

def disparar_webhook_tentativa(username, ip):
    url = "https://integrations.crionsolutions.com.br/webhook/e8ca2265-a387-486a-a5e2-f47a1de4b880"  # coloque o webhook do n8n aqui

    payload = {
        "evento": "falha_login_3x",
        "usuario": username,
        "ip": ip,
    }

    try:
        requests.post(url, json=payload, timeout=5)
    except:
        pass  # evita travar o login se o webhook falhar
