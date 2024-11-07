from django.shortcuts import render, redirect
from django.contrib import messages
from .models import Pessoa, Notas
from django.db.models import Avg, Sum, Count, F
from decimal import Decimal
from datetime import date
from django.db.models import Sum
from django.db.models.functions import TruncMonth
import matplotlib.pyplot as plt
from datetime import datetime
from django.http import JsonResponse
from django.http.response import Http404, HttpResponse
import json
from celery import shared_task
from datetime import timedelta
from django.contrib.auth.decorators import login_required




# from django.contrib.auth.decorators import login_required #Ver como funciona
# from .forms import PessoaForm, NotasForm
def landing(request):
    return render(request, 'landing.html')


# Create your views here.
def home(request):
    if  request.user.is_authenticated:
        pessoas = Pessoa.objects.all().order_by('-somanotas')
        pessoas_filtradas = Pessoa.objects.filter(valoratrasado__gt=1000).order_by('-valoratrasado')
        total_soma_notas = sum(pessoa.somanotas for pessoa in pessoas_filtradas)
        notas  = Notas.objects.all()
        notasPendentes = Notas.objects.filter(status = 'pendente')
        somanotas = float(notasPendentes.aggregate(Sum('valor'))['valor__sum'] or 0)
        notasPagas = notas.filter(status = 'pago')
        notasPagasSum = float(notasPagas.aggregate(Sum('valor'))['valor__sum'] or 0)
        notasAtrasadas = notas.filter(atrasada = 'sim', status='pendente')
        notasAtrasadasSum = float(notasAtrasadas.aggregate(Sum('valor'))['valor__sum'] or 0)
        notasAtrasadasPorMes = Notas.objects.filter(atrasada='sim', status='pendente').annotate(month=TruncMonth('data')).values('month').annotate(total=Sum('valor')).order_by('month') or 0
        notasPagasPorMes = Notas.objects.filter(status='pago').annotate(month=TruncMonth('dataRecebimento')).values('month').annotate(total=Sum('valor')).order_by('month')
        notasPendentesPorMes = Notas.objects.filter(status='pendente').annotate(month=TruncMonth('data')).values('month').annotate(total=Sum('valor')).order_by('month')
        # Transformar em dicionário
        pendentes_dict = {entry['month'].strftime('%Y-%m'): float(entry['total']) for entry in notasPendentesPorMes}
        pagas_dict = {entry['month'].strftime('%Y-%m'): float(entry['total']) for entry in notasPagasPorMes}
        atrasadas_dict = {entry['month'].strftime('%Y-%m'): float(entry['total']) for entry in notasAtrasadasPorMes}
        mes_atual = datetime.now().strftime('%Y-%m')
        recebidoAtual = pagas_dict.get(mes_atual,0) 
        vendaAtual = pendentes_dict.get(mes_atual, 0)


        # Criar um conjunto com todos os meses (de ambas as listas)
        todos_os_meses =  sorted(set(pendentes_dict.keys()).union(set(pagas_dict.keys())).union(set(atrasadas_dict.keys())))

        # Listas finais de meses e valores
        somaNotasPendentes = [pendentes_dict.get(mes, 0) for mes in todos_os_meses]
        somaNotasPagas = [pagas_dict.get(mes, 0) for mes in todos_os_meses]
        somaNotasAtrasadas = [atrasadas_dict.get(mes, 0) for mes in todos_os_meses]
        
        contexto = {
            "pessoas": pessoas,
            'somanotas': somanotas,
            'vendaAtual': vendaAtual,
            'recebidoAtual': recebidoAtual, 
            'recebidos': notasPagasSum,
            'atrasadas': notasAtrasadasSum,
            "meses": json.dumps(todos_os_meses),  # Enviar os meses como JSON
            "somaNotasPendentes": json.dumps(somaNotasPendentes),  # Valores das notas pendentes como JSON
            "somaNotasPagas": json.dumps(somaNotasPagas),
            "somaNotasAtrasadas": json.dumps(somaNotasAtrasadas),
            "recebidoMes": json.dumps(float(recebidoAtual)),
            "vendaMes": json.dumps(float(vendaAtual)),
            'pessoas_filtradas': pessoas_filtradas,
            'total_soma_notas': total_soma_notas
        }
        
        return render(request, "index.html", contexto)
    else:
        return(redirect(landing))





@login_required
def vendas(request):
    pessoas = Pessoa.objects.all()
    return render(request, "vendas.html", {"pessoas": pessoas})

@login_required
def inicio(request):
    return redirect(home)

@login_required
def cliente(request):
        query = request.GET.get('query')
        if query:
            pessoas = Pessoa.objects.filter(nome__icontains=query)
        else:
            pessoas = Pessoa.objects.all()

        context ={
            'pessoas': pessoas
        } 
        return render(request, "clientes.html",context)
       
      
           
@login_required
def notas(request):
    notas = Notas.objects.all()
    return render(request, "notas.html", {"notas": notas})

@login_required
def salvar(request):
    #Buscar os dados do html
    nome = request.POST.get("nome")
    cpf = request.POST.get("cpf")
    endereco = request.POST.get("endereco")
    telefone = request.POST.get("telefone")    
   
    if nome and endereco and telefone:
    #Criar no banco de dados
        Pessoa.objects.create(nome=nome, cpf = cpf,  telefone=telefone,endereco = endereco)
        #Atualizar a lista de pessoas
        pessoas = Pessoa.objects.all()
        #Mandar para o index com a lista atualizada
        return redirect(home)
    else: 
        messages.info(request, 'Você precisa informar todos os dados.')
        return redirect(novocliente)

@login_required
def novanota(request, id):
    pessoa = Pessoa.objects.get(id=id)
    data = date.today().strftime('%Y-%m-%d')
    return render(request, "novanota.html", {"pessoa": pessoa,"data":data})


@login_required
def criarnota(request):
    pessoa = Pessoa.objects.all()
    
    return render(request, "criarnota.html", {"pessoa": pessoa})

@login_required
def salvarnota(request, id):
    pessoa = Pessoa.objects.get(id=id)
    data = request.POST.get("data")
    valor = Decimal(request.POST.get("valor"))
    # assinatura = request.POST.get("endereco")
    if data and valor:
        Notas.objects.create(pessoa = pessoa, valor=valor, data=data)
        pessoa.somanotas = pessoa.somanotas + valor
        pessoa.save()
        #Atualizar a lista de pessoas
        notas = Notas.objects.all()
        #Mandar para o index com a lista atualizada
        # return render(request, "vernotas.html", {"notas": notas, 'pessoa': pessoa})
        return redirect(vernotas, pessoa.id)
    else:
        notas = Notas.objects.all()
        return render(request, "notas.html", {"notas": notas})

@login_required
def editar(request, id):
    pessoa = Pessoa.objects.get(id=id)
    return render(request, "update.html", {"pessoa": pessoa})
@login_required
def update(request, id):
    nome = request.POST.get("nome")
    cpf = request.POST.get("cpf")
    endereco = request.POST.get("endereco")
    telefone = request.POST.get("telefone")
    pessoa = Pessoa.objects.get(id=id)
    pessoa.nome = nome
    pessoa.cpf = cpf
    pessoa.endereco = endereco
    pessoa.telefone = telefone
    pessoa.save()
    return redirect(home)

@login_required
def editarNota(request, id):
    nota = Notas.objects.get(id=id)
    pessoa = Pessoa.objects.filter(id=nota.id)
    return render(request, "editarnota.html" , {'nota':nota, 'pessoa':pessoa})

@login_required
def salvarNota (request, id):
    nome = request.POST.get("nome")
    data= request.POST.get("data") 
    valor= request.POST.get("nome")
    status = request.POST.get("valor")
    nota = Notas.objects.get(id = id)
    if data and valor and status:
        nota.data = data
        nota.valor = valor
        nota.status = status
        nota.save()
    return redirect(notas)
@login_required
def deletarNota(request, id):
    nota = Notas.objects.get(id=id)
    pessoa = nota.pessoa
    idpessoa = pessoa.id
    nota.delete()    
    return redirect(vernotas, idpessoa)


    
@login_required
def excluir(request, id):
    pessoa = Pessoa.objects.get(id=id)
    pessoa.delete()
    return redirect(cliente)

@login_required
def novocliente(request):
    return render(request,'create_pessoa.html')

@login_required
def vernotas(request, id):
    pessoa = Pessoa.objects.get(id=id)
    notas = Notas.objects.filter(pessoa=pessoa.id)
    notasPendentes = notas.filter(status ='pendente')
    notasPagas = notas.filter(status ='pago')
    notasAtrasadas = notas.filter(atrasada ='sim', status='pendente')
    somanotas = notasPendentes.aggregate(Sum('valor'))['valor__sum'] or 0
    valorPendente = float((somanotas - pessoa.saldo ) or 0)
    return render(request, "vernotas.html", {
        "pessoa" : pessoa,
        "notasPendentes" : notasPendentes,
        'somanotas' : somanotas, 
        'notasPagas': notasPagas,        
        'valorPendente': valorPendente,
        'notasAtrasadas': notasAtrasadas
        })

@login_required
def darBaixa (request, id):
    pessoa = Pessoa.objects.get(id=id)
    valor_inserido = (request.POST.get("valorRecebido"))
    valor_inserido = Decimal(valor_inserido)
    data_recebimento = request.POST.get("dataRecebimento")
    notas = Notas.objects.filter(pessoa=pessoa.id)
    notasPendentes = notas.filter(status ='pendente')
    # Calcular o valor total dos boletos pendentes
    total_pendentes = notasPendentes.aggregate(Sum('valor'))['valor__sum'] or 0
    total_pendentes = Decimal(total_pendentes)
    saldo = pessoa.saldo
    # saldo = int(pessoa.saldo)
    saldo += valor_inserido 

    valor_restante = valor_inserido
    # Lista para armazenar boletos que serão pagos
    notas_para_baixa = []
    
    # Iterar sobre os boletos pendentes para dar baixa até que o valor inserido seja utilizado
    for nota in notasPendentes:
        if saldo >= nota.valor:
            saldo -= nota.valor
            nota.status = 'pago'
            nota.dataRecebimento = data_recebimento
            nota.save()
            notas_para_baixa.append(nota)
            pessoa.saldo = saldo
            pessoa.save() # Parar quando o valor inserido não for suficiente para o próximo boleto
        else:
            pessoa.saldo =saldo
            pessoa.save() 
                # Criar mensagem de erro
    contexto = {
        'boletos': notas_para_baixa,
        'valor_restante': valor_restante,
        'pessoa': pessoa,
        }
    return render(request, 'baixa_sucesso.html', contexto)
                   
@login_required
def receber(request, id):
    data_hoje = date.today().strftime('%Y-%m-%d')
    nota = Notas.objects.get(id= id)
    nota.status = 'pago'
    nota.dataRecebimento = data_hoje
    pessoa = nota.pessoa
    idpessoa = pessoa.id
    nota.save()
    return redirect(vernotas, idpessoa)

@login_required
def receberNota(request, id):
    pessoa = Pessoa.objects.get(id=id)
    somaNotas = pessoa.somanotas
    valorPendente =  pessoa.valorpendente
    
    data = date.today().strftime('%Y-%m-%d')
    return render(request, "receber.html", {'pessoa':pessoa, 'data':data,'somaNotas': somaNotas,'valorPendente':valorPendente})





@shared_task 
@login_required
def verificar_notas_atrasadas():
    notas = Notas.objects.all()
    for nota in notas:
        nota.atualizar_status()

def autenticar(request):
    from django.contrib.auth import authenticate, login
    username = request.POST.get("user")
    senha = request.POST.get("pswd")
    user = authenticate(username =username, password = senha)
    if user is not None:
        login(request, user)
        return redirect(home)
    else:
        print("Deu errado")
        return redirect(landing)

def logout_view(request):
    from django.contrib.auth import logout
    logout(request)
    return redirect(landing)
