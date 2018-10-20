#!/bin/sh
echo "Syncing keyvault secrets from deployment variables"

prazna="glava"
golema="dupka"
lozinka="tajna"
skrisno="mesto"
tajna="vecera"
 
relVars=("prazna-${prazna}" "golema-${golema}" "golema-${golema}" "lozinka-${lozinka}" "skrisno-${skrisno}" "tajna-${tajna}")

# relVars=('prazna-glava' 'golema-dupka' 'lozinka-tajna' 'skrisno-mesto' 'tajna-vecera')

# for i in ${relVars[@]} ; do 
#   KEY=${i%-*};
#   VAL=${i#*-};
#   echo $KEY" XX "$VAL;
# done

  
vaultName="u-vault"
servicePrincipalUserName="217da58d-ca29-4d68-b84f-808c441c94e3"
servicePrincipalPasword='!mal0Morgen'
azureSubscriptionTennantId="fc48caac-d828-4c3b-a47b-4740adceee99"


echo "authenticating to azure with a service principal credentials"
az login --service-principal \
    --username $servicePrincipalUserName \
    --password $servicePrincipalPasword \
    --tenant $azureSubscriptionTennantId


for i in ${relVars[@]} ; do 
  KEY=${i%-*};
  VAL=${i#*-};
  echo $KEY" XX "$VAL;

    secretValue=$(az keyvault secret show --vault-name $vaultName --name $KEY --query 'value' --output tsv)
    if [ -z "${secretValue}" ]
    then
        echo "$KEY is empty or it does not exist"
    else
        echo "$KEY is NOT empty"


        echo "comparing secretValue: ${secretValue} and VAL: ${VAL}"
        if [[ "${secretValue}" == "${VAL}" ]]
        then
            echo "$KEY has the same value"
        else
            echo "$KEY has new value -> will be updated"
            
            az keyvault secret set --vault-name $vaultName --name $KEY --value $VAL

        fi

        # az keyvault secret delete --vault-name $vaultName --name $secretName
        # az keyvault secret set --vault-name $vaultName --name $KEY --value $VAL

    fi

done



# for secretName in ${relVars[@]}; do
#     echo "processing secretName : $secretName"
# #     secretValue=$(az keyvault secret show --vault-name $vaultName --id $id --query 'value')
#      secretValue=$(az keyvault secret show --vault-name $vaultName --name $secretName --query 'value')
#      echo "secretValue : ${secretValue}"

#     if [ -z "${secretValue}" ]
#     then
#         echo "$secretName is empty or it does not exist"
#     else
#         echo "$secretName is NOT empty"
#         # az keyvault secret delete --vault-name $vaultName --name $secretName

#     fi



# done



# echo "getting the secrets from keyvault $vaultName"
# secrets=$( az keyvault secret list --vault-name $vaultName)


# echo $secrets | jq -c -r '.[].id' | while read id ; do
    
#     secretValue=$(az keyvault secret show --vault-name $vaultName --id $id --query 'value')
#     echo "secret: ${id}, value: ${secretValue} "

# done


