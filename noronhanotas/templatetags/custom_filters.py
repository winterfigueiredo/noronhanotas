from django import template
import locale
from babel.numbers import format_currency
register = template.Library()

@register.filter


def currency(value):
    # Configure locale de forma segura
    try:
        locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')
        use_locale = True
    except locale.Error:
        use_locale = False  # Fallback se o locale não for suportado

    # Certifique-se de que o valor é numérico
    try:
        value = float(value)  # Converte para float
    except (ValueError, TypeError):
        return "Invalid value"  # Retorna mensagem de erro para valores inválidos

    # Se o locale funcionar, use a função nativa de formatação
    if use_locale:
        return locale.currency(value, grouping=True)
    else:
        # Use Babel como fallback
        return format_currency(value, 'BRL', locale='pt_BR')

# Testes
   # Resultado esperado: Invalid value
