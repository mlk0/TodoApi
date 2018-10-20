#!/bin/sh

relVars=( "tajna-$(tajna)" "skrisno-$(skrisno)" "golema-$(golema)" "lozinka-$(lozinka)" "carevata-$(carevata)"  )
echo ${relVars[@]}

vaultName="u-vault"

for i in ${relVars[@]} ; do 
  KEY=${i%-*};
  VAL=${i#*-};
  echo "secret: $KEY" = "$VAL";

     secretValue=$(az keyvault secret show --vault-name $vaultName --name $KEY --query 'value' --output tsv)
     # echo "secretValue : ${secretValue}"

   if [ -z "${secretValue}" ]
    then
        echo "vault secret: ${KEY} is empty or it does not exist -> adding a new secret"
        az keyvault secret set --vault-name $vaultName --name $KEY --value $VAL --query "[?n]|[0]"
    else
        echo "$KEY is NOT empty"
         
        echo "comparing secretValue: ${secretValue} and VAL: ${VAL}"
        if [[ "${secretValue}" == "${VAL}" ]]
        then
            echo "$KEY has the same value"
        else
            echo "$KEY has new value -> will be updated"
            # az keyvault secret delete --vault-name $vaultName --name $KEY
            az keyvault secret set --vault-name $vaultName --name $KEY --value $VAL --query "[?n]|[0]"

        fi

    fi



done
 

 