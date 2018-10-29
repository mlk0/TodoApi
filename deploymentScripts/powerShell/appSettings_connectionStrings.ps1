param(
    [string] $azureSqlConnectionString_SQLAzure, # = "Server=tcp:__SERVER_NAME__.database.windows.net;Database=__DATABASE_NAME__; User ID=__DATABASE_LOGIN__@__SERVER_NAME__;Password=__DATABASE_LOGIN_PASSWORD__;Trusted_Connection=False;",
    [string] $sqlStandardConnectionString_SQLServer # = "Server=__SERVER_NAME__;Database=__DATABASE_NAME__;User Id=__DATABASE_LOGIN__; Password=__DATABASE_LOGIN_PASSWORD__;"

    ,[hashtable] $azureSqlConnection # = @{ Type = "SQLAzure" ; Value="Server=tcp:__SERVER_NAME__.database.windows.net;Database=__DATABASE_NAME__; User ID=__DATABASE_LOGIN__@__SERVER_NAME__;Password=__DATABASE_LOGIN_PASSWORD__;Trusted_Connection=False;" }

    )


$deploymentVariables = @{}
$deploymentVariables.Add("azureSqlConnectionString_SQLAzure",$azureSqlConnectionString_SQLAzure);
$deploymentVariables.Add("sqlStandardConnectionString_SQLServer",$sqlStandardConnectionString_SQLServer);
$deploymentVariables.Add("azureSqlConnection",$azureSqlConnection);

$deploymentVariables




# Import-Module Az
# $User = "d697cc1c-f558-46e1-aca8-6cc04be55d4b"
# $PWord = ConvertTo-SecureString -String "relDevAkses!@12" -AsPlainText -Force
# $credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
# Connect-AzAccount -Credential $credentials -TenantId fc48caac-d828-4c3b-a47b-4740adceee99 -ServicePrincipal


$resourceGroup = "dev"
$webAppName = "dev-tuduaApi"
$webApp = Get-AzureRmWebApp -ResourceGroupName $resourceGroup -Name $webAppName

if($webApp){
    Write-Host "webApp exists"
    #$webApp

    $siteConfig = $webApp.SiteConfig
    if($siteConfig){
        Write-Host "siteConfig exists"

        # $siteConfig

        $connectionStrings = $siteConfig.ConnectionStrings

        if($connectionStrings){
            Write-Host "connectionStrings exists"



            # convert the ConnectionStrings collection of Microsoft.Azure.Management.WebSites.Models.ConnStringInfo instances in a hashtable
            $connectionStringsHashtable = @{}
            # https://github.com/Azure/azure-powershell/issues/340#issuecomment-336971488
            # so Type MUST be STRING, but Name and Value, they do not have to have ToString() explicitly
            # foreach ($connectionString in $connectionStrings) {
            #     $setting =  @{Type=$connectionString.Type.ToString();Value=$connectionString.ConnectionString}
            #     $connectionStringsHashtable.Add($connectionString.Name,$setting);
            # }

            foreach ($item in $deploymentVariables.Keys) {
                Write-Host $item $deploymentVariables[$item] $deploymentVariables[$item].GetType()
               # $item.GetType()
                # Write-Host "$item -is $y.GetType() : $($x -is $y.GetType())"


                # if($item -is  hashtable){
                #     Write-Host $deploymentVariables[$item].Name $deploymentVariables[$item].Value
                # }

                # if($item -is [hashtable]){
                #     Write-Host $deploymentVariables[$item].Name $deploymentVariables[$item].Value
                # }

                # if($item -is [System.Collections.DictionaryEntry]){
                #     Write-Host $deploymentVariables[$item].Type $deploymentVariables[$item].Value
                # }


                if($deploymentVariables[$item] -is [System.Collections.Hashtable]){
                   Write-Host $deploymentVariables[$item].Type $deploymentVariables[$item].Value

                }


            }


        }
        #  $connectionStringsHashtable
        #  Set-AzureRMWebApp -ResourceGroupName $resourceGroup -Name $webAppName -ConnectionStrings $connectionStringsHashtable
    }
}
else
{
    Write-Host "webAppName : $webAppName does not exist"
}