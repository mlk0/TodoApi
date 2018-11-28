param(

    [hashtable] $connectionStringFormat_SQLAzure = @{ Type = "SQLAzure" ; Value="Server=tcp:__SERVER_NAME__.database.windows.net;Database=__DATABASE_NAME__; User ID=__DATABASE_LOGIN__@__SERVER_NAME__;Password=__DATABASE_LOGIN_PASSWORD__;Trusted_Connection=False;" },
    [hashtable] $connectionStringFormat_SQLServer = @{ Type = "SQLServer" ; Value="Server=__SERVER_NAME__;Database=__DATABASE_NAME__;User Id=__DATABASE_LOGIN__; Password=__DATABASE_LOGIN_PASSWORD__;" }


    )

    # initialize an empty hasthtable to store the values of the input arguments
    $deploymentVariables = @{}

    Get-Command $PSCommandPath | %{ $_.Parameters.GetEnumerator() | % {
        Write-Host "argument : $($_.Key)"
        $deploymentVariables.Add($_.Key,(Get-Variable $_.Key).Value);
    } }

# $deploymentVariables.Add("connectionStringFormat_SQLAzure",$connectionStringFormat_SQLAzure);
# $deploymentVariables.Add("connectionStringFormat_SQLServer",$connectionStringFormat_SQLServer);

Write-Host "checking the paremeters asignement"
foreach ($item in $deploymentVariables.Keys) {
    Write-Host "key : $($item) - Value : Type : $($deploymentVariables[$item].Type) - Value : $($deploymentVariables[$item].Value) is of type : $($deploymentVariables[$item].GetType())"
}





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
            foreach ($connectionString in $connectionStrings) {
                $setting =  @{Type=$connectionString.Type.ToString();Value=$connectionString.ConnectionString}
                $connectionStringsHashtable.Add($connectionString.Name,$setting);

                Write-Host "added $($connectionString.Name) in connectionStringsHashtable"
            }

            foreach ($deploymentVariableKey in $deploymentVariables.Keys) {
                # Write-Host $item $deploymentVariables[$deploymentVariableKey] $deploymentVariables[$deploymentVariableKey].GetType()
                Write-Host $deploymentVariables[$deploymentVariableKey] $deploymentVariables[$deploymentVariableKey].GetType()

                # work only with inputs that are of the right type of a hashtable and ignore all the others
                if($deploymentVariables[$deploymentVariableKey] -is [System.Collections.Hashtable]){
                    Write-Host "here is a hashtable"
                   Write-Host $deploymentVariables[$deploymentVariableKey].Type $deploymentVariables[$deploymentVariableKey].Value

                   if($connectionStringsHashtable.ContainsKey($deploymentVariableKey))
                   {
                       Write-Host "Updating : $($deploymentVariableKey)"
                        $connectionStringsHashtable[$deploymentVariableKey] = $deploymentVariables[$deploymentVariableKey]
                    }
                    else{
                       Write-Host "Adding : $($deploymentVariableKey)"

                        $connectionStringsHashtable.Add($deploymentVariableKey , $deploymentVariables[$deploymentVariableKey])
                    }

                }
                else{
                    Write-Host "The value of the deployment variable '$($deploymentVariableKey)' is of type of : $($deploymentVariableKey.GetType()) while the expected type is Hashtable"
                }




            }


        }
        #  $connectionStringsHashtable
          Set-AzureRMWebApp -ResourceGroupName $resourceGroup -Name $webAppName -ConnectionStrings $connectionStringsHashtable
    }
}
else
{
    Write-Host "webAppName : $webAppName does not exist"
}