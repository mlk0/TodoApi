
Import-Module Az

# $credentials = Get-Credential
$User = "217da58d-ca29-4d68-b84f-808c441c94e3"
$PWord = ConvertTo-SecureString -String "!mal0Morgen" -AsPlainText -Force
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

Connect-AzAccount -Credential $credentials -TenantId fc48caac-d828-4c3b-a47b-4740adceee99 -ServicePrincipal

Import-Module Az.Resources
Get-AzureRmResourceGroup
Get-AzureRmKeyVault | Select Location

Get-AzureRmKeyVault | Format-Table
Get-AzureRmKeyVault | Select VaultName,ResourceGroupName
Get-AzureRmKeyVault | Where VaultName -like d-* | Select VaultName,ResourceGroupName |  Format-Table
Get-AzureKeyVaultSecret -VaultName 'u-vault'
Get-AzureKeyVaultSecret -VaultName 'u-vault' -name carevata | Select-Object -Property SecretValueText,Name

ConvertTo-SecureString -String "skrisno" -AsPlainText -Force | Select-Object