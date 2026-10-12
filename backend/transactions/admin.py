import csv
from collections import defaultdict
from decimal import Decimal

from django.contrib import admin
from django.http import HttpResponse
from django.shortcuts import render
from django.urls import path
from django.utils import timezone

from .models import Transaction


@admin.action(description="Export selected transactions to CSV")
def export_to_csv(modeladmin, request, queryset):
    response = HttpResponse(content_type="text/csv")
    response["Content-Disposition"] = 'attachment; filename="transactions.csv"'

    writer = csv.writer(response)
    writer.writerow(["ID", "Transaction ID", "User", "Amount", "Status", "Date"])

    for t in queryset.select_related("user"):
        writer.writerow([
            t.id,
            t.transaction_id,
            t.user.username,
            t.amount,
            t.status,
            timezone.localtime(t.created_at).strftime("%Y-%m-%d %H:%M"),
        ])

    return response


@admin.register(Transaction)
class TransactionAdmin(admin.ModelAdmin):
    list_display = ["transaction_id", "user", "amount", "status", "created_at"]
    list_filter = ["status", "created_at"]
    search_fields = ["transaction_id", "user__username"]
    actions = [export_to_csv]

    def get_urls(self):
        urls = super().get_urls()
        custom = [
            path(
                "daily-summary/",
                self.admin_site.admin_view(self.daily_summary),
                name="transactions_daily_summary",
            ),
        ]
        return custom + urls

    def daily_summary(self, request):
        days = defaultdict(lambda: {
            "total": 0, "success": 0, "failed": 0, "pending": 0, "amount": Decimal("0"),
        })

        for t in Transaction.objects.all():
            day = timezone.localtime(t.created_at).date()
            days[day]["total"] += 1

            if t.status == "SUCCESS":
                days[day]["success"] += 1
                days[day]["amount"] += t.amount
            elif t.status == "FAILED":
                days[day]["failed"] += 1
            else:
                days[day]["pending"] += 1

        rows = []
        for day, stats in sorted(days.items(), reverse=True):
            stats["day"] = day
            rows.append(stats)

        context = {
            **self.admin_site.each_context(request),
            "title": "Daily Payment Summary",
            "rows": rows,
        }
        return render(request, "admin/transactions/daily_summary.html", context)
