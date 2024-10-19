# from django import forms
# # from .models import Pessoa, Notas

# # class PessoaForm(forms.ModelForm):
# #     class Meta:
# #         model = Pessoa
# #         fields = ['nome','endereco','telefone','credito','somanotas','saldo']

# # class NotasForm(forms.ModelForm):
# #     model = Notas
# #     fields = ['pessoa','valor','data','paga']


# class CPFForm(forms.Form):
#     cpf = forms.CharField(max_length=11, label="CPF", widget=forms.TextInput(attrs={'placeholder': 'Digite seu CPF'}))