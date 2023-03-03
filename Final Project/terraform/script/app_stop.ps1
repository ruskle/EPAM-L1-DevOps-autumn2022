$resourceGroupName = Get-AutomationVariable -Name "rg_name"
$servicePrincipalAppID = Get-AutomationVariable -Name "app_id"
$tenantId = Get-AutomationVariable -Name "tenant_id"
$spPassword = Get-AutomationVariable -Name "app_key"
$webAppName = Get-AutomationVariable -Name "web_app_name"

$password = ConvertTo-SecureString $spPassword -AsPlainText -Force
$psCredentials = New-Object System.Management.Automation.PSCredential ($servicePrincipalAppID, $password)

Connect-AzAccount -ServicePrincipal -Credential $psCredentials -Tenant $tenantId
Stop-AzWebApp -ResourceGroupName $resourceGroupName -Name $webAppName
