
# Importar o módulo necessário
Import-Module AzureRM

# Autenticar no Azure
$patToken = ""
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":$($patToken)")))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Definir a organização, o projeto, o backlog item e o caminho do arquivo
$organization = "MLTECNO02"
$project = "cloudengennier"
$backlogItem = "3918"
$filePath = "F:\Codificação\azuredevops\tasks.txt"

# Conectar ao Azure DevOps
#Connect-AzureRmAccount

# Ler o arquivo de texto
$tasks = Get-Content $filePath

# Construir a URL completa do item de backlog
$backlogItemUrl = "https://dev.azure.com/$organization/_apis/wit/workItems/$backlogItem"

echo "Serão criadas" $tasks.Count  "tasks"

# Iterar sobre as linhas do arquivo de texto
foreach ($taskName in $tasks) {
    # Verificar se a tarefa já existe
    $url = "https://dev.azure.com/$organization/$project/_apis/wit/wiql?api-version=6.0"
    $body = @"
    {
        "query": "SELECT [System.Id], [System.Title], [System.WorkItemType] FROM workitems WHERE [System.TeamProject] = '$project' AND [System.Title] = '$taskName'"
    }
"@
    $existingTask = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" -Headers $headers

    if ($existingTask.workItems.Count -gt 0) {
        echo ""
        echo "############### ATENÇÃO : A TAsk '$taskName' já existe no Backlogitem Nº: $backlogItem e não será criada ###################."     
        echo ""
        continue
    }

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

