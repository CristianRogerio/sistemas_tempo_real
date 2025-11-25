from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from django.utils import timezone
from .models import LoginAttempt
from .utils import disparar_webhook_tentativa

def get_client_ip(request):
    x_forwarded_for = request.META.get("HTTP_X_FORWARDED_FOR")
    if x_forwarded_for:
        return x_forwarded_for.split(",")[0]
    return request.META.get("REMOTE_ADDR")

def login_view(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        ip = get_client_ip(request)

        user = authenticate(request, username=username, password=password)

        if user is not None:
            # Login OK → limpa tentativas antigas
            LoginAttempt.objects.filter(username=username).delete()
            login(request, user)
            return redirect("/admin/")
        else:
            # Registrar tentativa de falha
            LoginAttempt.objects.create(username=username, ip=ip)

            # Contar falhas nos últimos 2 minutos
            total_falhas = LoginAttempt.failed_attempts_in_window(username, ip)

            if total_falhas >= 3:
                disparar_webhook_tentativa(username, ip)

            return render(request, "incidentes/login.html", {
                "error": "Usuário ou senha incorretos."
            })

    return render(request, "incidentes/login.html")
