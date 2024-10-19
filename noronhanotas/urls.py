from django.contrib import admin
from django.urls import path, include
from .views import *

from django.conf import settings
from django.conf.urls.static import static

# home, vendas, vernotas, inicio, salvar, editar, update, excluir, novocliente, cliente, notas, novanota, salvarnota
urlpatterns = [
    path('', landing, name='home'), 
    path('home/', home, name="home"),
    path('salvar/', salvar, name="salvar"),
    path('autenticar/', autenticar, name="autenticar"),
    path('logout/', logout_view, name="logout"),
    path('editar/<int:id>', editar, name="editar"),
    path('update/<int:id>', update, name="update"),
    path('excluir/<int:id>', excluir, name="excluir"),
    path('novo_cliente/', novocliente, name="novocliente"),
    path('cliente/', cliente, name="cliente"),
    path('notas/', notas, name="notas"),
    path('vendas/', vendas, name="vendas"),
    path('novanota/<int:id>', novanota, name="novanota"),
    path('criarnota/', criarnota, name="criarnota"),
    path('vernotas/<int:id>', vernotas, name="vernotas"),
    path('salvarnota/<int:id>', salvarnota, name="salvarnota"),
    path('receber/<int:id>', receber, name="receber"),
    path('darBaixa/<int:id>', darBaixa, name="darBaixa"),
    path('receberNota/<int:id>', receberNota, name="receberNota"),
    path('editarNota/<int:id>', editarNota, name="editarNota"),
    path('deletarNota/<int:id>', deletarNota, name="deletarNota"),
]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)