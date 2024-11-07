

from django.core.management.base import BaseCommand
from django.core.management.base import BaseCommand
from django.db.models import Sum, F
from ...models import Pessoa, Notas  # Altere 'seu_app' para o nome da sua aplicação
import datetime
from datetime import timedelta

class Command(BaseCommand):
    help = 'Your command description here'

    
    def handle(self, *args, **kwargs):
            hoje = datetime.datetime.now().date()
            
            # Atualiza os registros de Pessoa
            pessoas = Pessoa.objects.all()
            
            for pessoa in pessoas:
                # Calcula somanotas
                somanotas = round(pessoa.notas.filter(status='pendente').aggregate(Sum('valor'))['valor__sum'] or 0, 2)
                
                # Atualiza valoratrasado
                valoratrasado = round(pessoa.notas.filter(atrasada='sim',status = 'pendente').aggregate(Sum('valor'))['valor__sum'] or 0, 2)
                valoratrasado = valoratrasado - pessoa.saldo
                # Atualiza valorpendente
                valorpendente = pessoa.somanotas - pessoa.saldo
                
                
                # Salva os valores calculados
                pessoa.somanotas = somanotas
                pessoa.valoratrasado = valoratrasado
                pessoa.valorpendente = valorpendente
                pessoa.save()

                self.stdout.write(self.style.SUCCESS(f'Atualizado: {pessoa.nome}, Valor Pendente: {valorpendente}, Valor Atrasado: {valoratrasado}'))

            self.stdout.write(self.style.SUCCESS('Atualização completa!'))