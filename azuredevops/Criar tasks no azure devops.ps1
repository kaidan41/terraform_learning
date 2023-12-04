# Importar o módulo necessário
Import-Module AzureRM

# Autenticar no Azure
$patToken = "gd4ic4tssawj4rnrmtbgs4p56npg25rde3p2cshen4kabmctuaga"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":$($patToken)")))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Definir a organização, o projeto, o backlog item e o caminho da planilha
$organization = "MLTECNO02"
$project = "cloudengennier"
$backlogItem = "2599"
$excelPath = "F:\Codificação\azuredevops\conta02.xlsx"

# Conectar ao Azure DevOps
Connect-AzureRmAccount

# Abrir a planilha do Excel
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Open($excelPath)
$worksheet = $workbook.Worksheets.Item(1)
$range = $worksheet.UsedRange

# Construir a URL completa do item de backlog
$backlogItemUrl = "https://dev.azure.com/$organization/_apis/wit/workItems/$backlogItem"

echo "Serão criadas" $range.Rows.Count  "tasks"

# Iterar sobre as linhas da segunda coluna
for ($i = 1; $i -le $range.Rows.Count; $i++) {
    $taskName = $range.Cells.Item($i, 2).Text

    # Criar uma nova tarefa no Azure DevOps
    $url = "https://dev.azure.com/$organization/$project/_apis/wit/workitems/`$Task?api-version=6.0"
    $body = @"
    [
        {
            "op": "add",
            "path": "/fields/System.Title",
            "value": "$taskName"
        },
        {
            "op": "add",
            "path": "/relations/-",
            "value": {
                "rel": "System.LinkTypes.Hierarchy-Reverse",
                "url": "$backlogItemUrl",
                 "attributes": {
        "comment": "Criado a partir de um script PowerShell por Marcos Silva-Cloud"
    }
            }
        }
    ]
"@
    Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json-patch+json" -Headers $headers
}

# Fechar a planilha do Excel
$excel.Quit()