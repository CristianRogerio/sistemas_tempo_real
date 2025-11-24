from django.contrib import admin
from django.urls import path, include
from django.shortcuts import redirect

urlpatterns = [
    # Redireciona / → /login
    path('', lambda request: redirect('login')),

    # Rotas do app incidentes
    path('', include('incidentes.urls')),

    # Admin
    path('admin/', admin.site.urls),
]
