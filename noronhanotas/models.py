from django.db import models
from datetime import timedelta
import datetime 
from django.db.models import  F, Sum


# Create your models here.

        
class Pessoa(models.Model):
    nome = models.CharField(max_length=100)
    endereco = models.TextField(default="")
    telefone = models.CharField(max_length=20, default="")
    credito = models.DecimalField(max_digits=10, decimal_places=2, default=500)
    somanotas = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    saldo = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    cpf = models.DecimalField(max_digits=11, decimal_places=0, default=00000000000)
    valorpendente = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    valoratrasado = models.DecimalField(max_digits=10, decimal_places=2, default=0)



    def __str__(self):
        return self.nome
    
    def calc_valor_pendente(self):
        return self.somanotas - self.saldo if self.somanotas > 0 else 0  # Evita que seja None
    
    def save(self, *args, **kwargs):
        notas = Notas.objects.filter(pessoa=self)
        # Atualiza somanotas antes de calcular os valores pendentes e atrasados
        self.somanotas = round(notas.filter(status = 'pendente').aggregate(Sum('valor'))['valor__sum'] or 0, 2)
        
        # Calcule o valor atrasado somando valores com status 'atrasada'
        self.valoratrasado = round(notas.filter(atrasada='sim',status = 'pendente').aggregate(Sum('valor'))['valor__sum'] or 0, 2) - self.saldo
        # Calcule o valor pendente com base na soma das notas e saldo
        self.valorpendente = self.calc_valor_pendente()
        
        # Atualiza o status das notas que estão atrasadas
        hoje = datetime.datetime.now().date()
        Notas.objects.filter(data__lt=hoje - timedelta(days=30)).update(atrasada='sim')
        
        # Salva o objeto Pessoa com os novos valores calculados
        super().save(*args, **kwargs)
    
class Notas(models.Model):
    pessoa = models.ForeignKey(Pessoa, related_name='notas', on_delete=models.CASCADE)
    valor = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    data = models.DateField()
    dataRecebimento = models.DateField(default= datetime.datetime.now)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(default= datetime.datetime.now)
    status = models.CharField(max_length=20, default='pendente')
    atrasada = models.CharField(max_length=20, default='não')
    def __str__(self):
        return f"{self.pessoa.nome} {self.valor}"

