from django.contrib import admin

from .models import Card


@admin.register(Card)
class CardAdmin(admin.ModelAdmin):

    list_display = (
        'id',
        'user',
        'card_type',
        'masked_card',
        'last_four',
        'expiry_month',
        'expiry_year',
        'created_at',
    )

    list_filter = (
        'card_type',
        'expiry_year',
    )

    search_fields = (
        'user__username',
        'user__email',
        'last_four',
    )

    readonly_fields = (
        'masked_card',
        'last_four',
        'created_at',
        'updated_at',
    )