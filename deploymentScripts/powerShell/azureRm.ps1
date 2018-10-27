


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






Import-Module Az

# $credentials = Get-Credential
$User = "3300c5b5-6d50-4d57-a47b-c6de3063f024"
$PWord = ConvertTo-SecureString -String "a@Access!@#123" -AsPlainText -Force
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

Connect-AzAccount -Credential $credentials -TenantId fc48caac-d828-4c3b-a47b-4740adceee99 -ServicePrincipal


Import-Module Az
$User = "d697cc1c-f558-46e1-aca8-6cc04be55d4b"
$PWord = ConvertTo-SecureString -String "relDevAkses!@12" -AsPlainText -Force
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

Connect-AzAccount -Credential $credentials -TenantId fc48caac-d828-4c3b-a47b-4740adceee99 -ServicePrincipal

Import-Module Az.Resources
Get-AzureRmResourceGroup

