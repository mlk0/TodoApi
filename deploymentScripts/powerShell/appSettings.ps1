

$deploymentVariables = @{}

$deploymentVariables.Add("appHost","$(appHost)");
$deploymentVariables.Add("environmentCode","$(environmentCode)");
$deploymentVariables.Add("maxItems","$(maxItems)");
$deploymentVariables.Add("keyvault:name","$(keyvaultName)");
$deploymentVariables.Add("keyvault:appId","$(keyvaultAppId)");
$deploymentVariables.Add("keyvault:password","$(keyvaultPassword)");

# $deploymentVariables.Add("appHost","azure");
# $deploymentVariables.Add("environmentCode","dev");
# $deploymentVariables.Add("maxItems","2");

# $deploymentVariables.Add("keyvault:name","d-vault");
# $deploymentVariables.Add("keyvault:appId","442b3726-a741-4a65-86b5-6efee00a63e9");
# $deploymentVariables.Add("keyvault:password","runDevAkses!@12");





Import-Module Az
$User = "d697cc1c-f558-46e1-aca8-6cc04be55d4b"
$PWord = ConvertTo-SecureString -String "relDevAkses!@12" -AsPlainText -Force
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

Connect-AzAccount -Credential $credentials -TenantId fc48caac-d828-4c3b-a47b-4740adceee99 -ServicePrincipal

# Import-Module Az.Resources
Get-AzureRmResourceGroup

$resourceGroup = "dev"
$webAppName = "dev-tuduaApi"
$webApp = Get-AzureRmWebApp -ResourceGroupName $resourceGroup -Name $webAppName

if($webApp){
    Write-Host "webApp exists"
    #$webApp

    $siteConfig = $webApp.SiteConfig
    if($siteConfig){
        Write-Host "siteConfig exists"

        #$siteConfig

        $appSettings = $siteConfig.AppSettings

        if($appSettings){
            Write-Host "appSettings exists"
            #$appSettings.GetType()

            # convert the AppSettings collection of NameValuePair in a hashtable
            $appSettingsHashtable = @{}
            foreach ($item in $appSettings) {
                $appSettingsHashtable.Add($item.Name, $item.Value)
            }

            foreach ($deploymentVariableKey in $deploymentVariables.Keys) {
                #Write-Host $deploymentVariableKey $deploymentVariables[$deploymentVariableKey]


                if($appSettingsHashtable.ContainsKey($deploymentVariableKey)){
                    $appSettingsHashtable[$deploymentVariableKey] = $deploymentVariables[$deploymentVariableKey]
                }
                else{
                    $appSettingsHashtable.Add($deploymentVariableKey , $deploymentVariables[$deploymentVariableKey])
                }
            }

            #Write-Host $appSettingsHashtable.GetType()

            #Write-Host $appSettingsHashtable
            # $appSettingsHashtable.Keys
            # $appSettingsHashtable.Values
            foreach ($key in $appSettingsHashtable.Keys) {
                Write-Host "$appSettingsHashtable[$key] = $($appSettingsHashtable[$key])"
            }

            Set-AzureRMWebApp -ResourceGroupName $resourceGroup -Name $webAppName -AppSettings $appSettingsHashtable
        }
    }




}
else{
    Write-Host "webAppName : $webAppName does not exist"
}