from django.db import models
from datetime import timedelta
import datetime 
from django.db.models import  F


# Create your models here.

        
class Pessoa(models.Model):
    nome = models.CharField(max_length=100)
    endereco = models.TextField(default="")
    telefone = models.CharField(max_length=20, default="")
    credito = models.DecimalField(max_digits=10, decimal_places=2, default=500)
    somanotas = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    saldo = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    cpf = models.DecimalField(max_digits=11, decimal_places=0, default=00000000000)
   
    def __str__(self):
        return self.nome
    # Método para somar todas as notas associadas a essa pessoa
    def soma_notas(self):
        return sum(self.notas.filter(status = 'pendente').values_list('valor', flat=True))

    
class Notas(models.Model):
    pessoa = models.ForeignKey(Pessoa, related_name='notas', on_delete=models.CASCADE)
    valor = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    data = models.DateField()
    dataRecebimento = models.DateField(default= datetime.datetime.now)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(default= datetime.datetime.now)
    # vencimento = models.DateField(null=True, blank=True)
    # data_venc = models.DateTimeField(blank=True)
    status = models.CharField(max_length=20, default='pendente')
    atrasada = models.CharField(max_length=20, default='não')
    # paga = models.BooleanField()
    def __str__(self):
        return f"{self.pessoa.nome} {self.valor}"
    
    @staticmethod
    def atualizar_vencidas():
        hoje = datetime.datetime.now().date()
        Notas.objects.filter(data__lt=hoje - timedelta(days=30)).update(atrasada= 'sim')

    
    # def salvar_vencimento(self):
    #     if self.data:
    #         # self.vencimento = F(self.data) + timedelta(days=30)
    #         self.data_venc = self.data + timedelta(days=30)
    #     super(Notas, self).save()

    # def save(self, *args, **kwargs):
    #     self.salvar_vencimento()
    #     super().save(*args, **kwargs)
    
# Notas.objects.update(vencimento=F('data') + timedelta(days=30))