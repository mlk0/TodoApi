
param(
    [string] $appHost,
     [string] $environmentCode,
     [string] $maxItems,
     [string] $keyvaultName,
     [string] $keyvaultAppId,
     [string] $keyvaultPassword

    )

$deploymentVariables = @{}

Write-Host $appHost $environmentCode $maxItems $keyvaultName  $keyvaultAppId  $keyvaultPassword

$deploymentVariables.Add("appHost",$appHost);
$deploymentVariables.Add("environmentCode",$environmentCode)
$deploymentVariables.Add("maxItems",$maxItems)
$deploymentVariables.Add("keyvault:name",$keyvaultName)
$deploymentVariables.Add("keyvault:appId",$keyvaultAppId)
$deploymentVariables.Add("keyvault:password",$keyvaultPassword)




$resourceGroup = $environmentCode
$webAppName = "$($environmentCode)-tuduaApi"
$webApp = Get-AzureRmWebApp -ResourceGroupName $resourceGroup -Name $webAppName

if($webApp){
    Write-Host "webApp $($webAppName) exists"


    $siteConfig = $webApp.SiteConfig
    if($siteConfig){
        Write-Host "siteConfig exists"

        $appSettings = $siteConfig.AppSettings

        if($appSettings){

            # 1. convert the AppSettings collection of NameValuePair in a hashtable
            $appSettingsHashtable = @{}
            foreach ($item in $appSettings) {
                $appSettingsHashtable.Add($item.Name, $item.Value)
            }

            # 2. iterate over each of the deployment variables
            foreach ($deploymentVariableKey in $deploymentVariables.Keys) {
                #Write-Host $deploymentVariableKey $deploymentVariables[$deploymentVariableKey]

                if($appSettingsHashtable.ContainsKey($deploymentVariableKey)){
                    $appSettingsHashtable[$deploymentVariableKey] = $deploymentVariables[$deploymentVariableKey]
                }
                else{
                    $appSettingsHashtable.Add($deploymentVariableKey , $deploymentVariables[$deploymentVariableKey])
                }
            }

            # list all the items from the app settings for log purposes
            foreach ($key in $appSettingsHashtable.Keys) {
                Write-Host "$appSettingsHashtable[$key] = $($appSettingsHashtable[$key])"
            }

            # update the webApp with the set of app settingsß
            Set-AzureRMWebApp -ResourceGroupName $resourceGroup -Name $webAppName -AppSettings $appSettingsHashtable
        }
    }




}
else{
    Write-Host "webAppName : $webAppName does not exist"
}