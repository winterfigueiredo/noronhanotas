from django import template
import locale

register = template.Library()

@register.filter



def currency(value):
    locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')

    # Ensure value is numeric
    try:
        value = float(value)  # Convert to float
    except (ValueError, TypeError):
        return "Invalid value"  # Handle the case where conversion fails

    return locale.currency(value, grouping=True)