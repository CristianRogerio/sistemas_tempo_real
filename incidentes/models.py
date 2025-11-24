from django.db import models
from django.utils import timezone
from datetime import timedelta

class LoginAttempt(models.Model):
    username = models.CharField(max_length=150)
    ip = models.GenericIPAddressField()
    timestamp = models.DateTimeField(auto_now_add=True)

    @staticmethod
    def failed_attempts_in_window(username, ip, minutes=2):
        time_threshold = timezone.now() - timedelta(minutes=minutes)
        return LoginAttempt.objects.filter(
            username=username,
            ip=ip,
            timestamp__gte=time_threshold
        ).count()
