import openpyxl



import openpyxl


# Caminho do arquivo Excel (no Desktop do Windows)
caminho_arquivo = 'F:/codificação/azuredevops/planilha_dados.xlsx'

# Cria um novo arquivo Excel
workbook = openpyxl.Workbook()

# Seleciona a planilha padrão (index 0)
sheet = workbook.active

# Adiciona dados à planilha
num_linhas = 1000
num_colunas = 10

# Loop para adicionar dados
for linha in range(1, num_linhas + 1):
    for coluna in range(1, num_colunas + 1):
        # Insere dados de exemplo (números incrementais)
        sheet.cell(row=linha, column=coluna, value=linha * coluna)

# Salva o arquivo Excel no local especificado
workbook.save(caminho_arquivo)
