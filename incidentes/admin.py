from django.contrib import admin
from .models import LoginAttempt

@admin.register(LoginAttempt)
class LoginAttemptAdmin(admin.ModelAdmin):
    list_display = ("username", "ip", "timestamp")
    list_filter = ("username", "ip", "timestamp")
    search_fields = ("username", "ip")
    ordering = ("-timestamp",)
