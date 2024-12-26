import pandas as pd
from scipy.stats import spearmanr

# Carregar os dados do arquivo Excel
data = pd.read_excel('bdCeliana.xlsx', sheet_name="bdCeliana")

# Filtrar os dados para diagnóstico igual a "SCA2"
filtered_data = data[data['diagnóstico'] == 'SCA2']

# Variáveis para calcular a correlação
variables = ['cvf', 'vef1', 'vef1cvf']
correlations = []
p_values = []

for var in variables:
    rho_idade, p_val_idade = spearmanr(filtered_data[var], filtered_data['idade'])
    rho_tempo_doenca, p_val_tempo_doenca = spearmanr(filtered_data[var], filtered_data['tempodoença'])
    correlations.append([rho_idade, rho_tempo_doenca])
    p_values.append([p_val_idade, p_val_tempo_doenca])

# Criar DataFrames para armazenar os resultados
correlation_df = pd.DataFrame(correlations, columns=['idade', 'tempodoença'], index=variables)
p_value_df = pd.DataFrame(p_values, columns=['idade', 'tempodoença'], index=variables)

# Criar uma tabela combinada de correlações e p-valores
results = pd.DataFrame(index=variables)
results['Idade_rho'] = correlation_df['idade']
results['Idade_p'] = p_value_df['idade']
results['TempoDoenca_rho'] = correlation_df['tempodoença']
results['TempoDoenca_p'] = p_value_df['tempodoença']

# Exportar os resultados para um arquivo Excel
results.to_excel('correlation_results.xlsx', sheet_name='Spearman_Correlation')

print("Análise de correlação concluída e resultados exportados para correlation_results.xlsx")
