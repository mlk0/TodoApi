#!/bin/sh
echo "Hello Azure CLI!"

vaultName="u-vault"
az login --service-principal --username "217da58d-ca29-4d68-b84f-808c441c94e3" --password '!mal0Morgen' --tenant "fc48caac-d828-4c3b-a47b-4740adceee99"
secrets=$( az keyvault secret list --vault-name $vaultName --output json)
echo "printing the secrets - ${secrets[*]}"

numberOfSecrets=${#secrets[*]}
echo "# of secrets $numberOfSecrets"




secretLisTableLen=$(az keyvault secret list --vault-name $vaultName --output json --query 'length([*].{ID:id, DateCreated:attributes.created})')
echo $secretLisTableLen
echo "secretLisTableLen: ${secretLisTableLen}" 


secretIds=$(az keyvault secret list --vault-name $vaultName --query "[*].id")
echo "printing the secrets - ${secretIds[*]}"
numberOfSecretIDs=${#secretIds[*]}
echo "# of numberOfSecretIDs: $numberOfSecretIDs"




compare_secrets ()
{
  echo "compare_secrets"
  echo $0

  echo $1
  echo $2

  if [[ $1 = $2 ]] ;
    then
        echo "the two secret values are equal"
    else
        echo "the two secret values are not equal - update of the secret needs to be made"
        # az keyvault secret delete --vault-name $vaultName --name tajna
        az keyvault secret set --vault-name $vaultName --name tajna --value "$1"


    fi
}

 


release_var_secret_value_tajna="qa slatka gorka"
secret_value_tajna=$(az keyvault secret show --vault-name $vaultName --name tajna --query value --output tsv)

echo "release_var_secret_value_tajna: $release_var_secret_value_tajna" 
echo "secret_value_tajna: $secret_value_tajna"

compare_secrets "$release_var_secret_value_tajna" "$secret_value_tajna"

# echo $secret_value_tajna
# if [[ $release_var_secret_value_tajna = $secret_value_tajna ]] ;
# then
#     echo "the two secret values are equal"
# else
#     echo "the two secret values are not equal - update of the secret needs to be made"
# fi


# the initial intention was to get all the secrets and to iterate in the collection of secrets
# then to get the value for each of the secrets and to compare it with the value of the secured variable in Release Manager
# in the case when those 2 values are different, to set the new value for the variable.
# it looks like even though the json data is returned as an array, the bash is identifying all that as an array of a single item
# even when JMESPATH length function returns 4 (the actual number of secrets), the ${#secrets[*]} will still say that there is ony 1 item
# so looping through the json result would not be possible
# one possible solutiuon would be to use the jq library https://medium.com/cameron-nokes/working-with-json-in-bash-using-jq-13d76d307c4
# which is intended to add JSON manipulation support to bash scripting
# Other approach would be to use a different algorihm for managing the secrets:
# Each new deployment clears all the secrets from the vault before adds the new values.
# the benefits of this approach would be that there will eliminate the need to 
# 1. update an existing secret value if it's different
# 2. add a new secret in the vault if it's not there
# 3. remove a secret from the vault in case where the Release Manager Release definiton does not have any matching item for a secret in the vault
# the 3 cases were part of the original intention and it's obvious that the logic is unnecessary complicated when compared to the second approach
# in which is considered tha teach new deployment will actually specify the correct set of the secrets needed to be added in the vault (after deleteing whatever collction is inside)




# secretLisTableType=$(az keyvault secret list --vault-name u-vault --output json --query 'type([*].{ID:id, DateCreated:attributes.created})')
# echo "secretLisTableType: $secretLisTableType"


# aaa=$(az keyvault secret list --vault-name u-vault --output json --query '[*].{ID:id, DateCreated:attributes.created}')
# echo $aaa

# for m in '${aaa[@]}'
# do
#     echo ${m["id"]}    
#     # echo "iterationdfssdsdsds"
# done


# hm=$(az keyvault secret list --vault-name u-vault --output json --query '[*].{ID:id, DateCreated:attributes.created}')
# echo $hm

# # secretLisTable=$(az keyvault secret list --vault-name u-vault --output json --query '[*].{ID:id, DateCreated:attributes.created}')
# secretLisTable=$(az keyvault secret list --vault-name u-vault --output table --query 'to_array([*].[id, attributes.created])')
# echo "# of secrets in secretLisTable : ${#secretLisTable[*]}"
# # echo ${secretLisTable[@]}

# # echo ${secretLisTable[0]}
# echo ${secretLisTable[1]}
# echo ${secretLisTable[2]}
# echo ${secretLisTable[3]}

# iteration=1
# for sec in "${secretLisTable[@]}"
# do
#     echo "iteration : $iteration"
# done

# secretLisTable=$(az keyvault secret list --vault-name u-vault --output json --query '[*].{ID:id, DateCreated:attributes.created}')
# echo "# of secrets in secretLisTable : ${#secretLisTable[*]}"
# echo ${secretLisTable[@]}



# secretLisTable2=$( az keyvault secret list --vault-name u-vault --output table --query '[*].[id, attributes.created]' )
# echo "# of secrets in secretLisTable2 : ${#secretLisTable2[*]}"
# echo ${secretLisTable2[@]}



# secretLisJson=$( az keyvault secret list --vault-name u-vault --output json --query '[*].{ID:id, DateCreated:attributes.created}' )
# echo "# of secrets in secretLisJson : ${#secretLisJson[*]}"
# echo ${secretLisJson[@]}



#  secretLis=$( az keyvault secret list --vault-name u-vault --output table --query '[*].{ID:id, DateCreated:attributes.created}' )

# # secretLis=$( az keyvault secret list --vault-name u-vault --output json --query '[*].[id, attributes.created]' )

# numberOfSecrets2=${#secretLis[*]}
# echo "# of secrets2 $numberOfSecrets2"

# echo ${secretLis[*]}

# for s in ${secretLis[@]}
# do
#     # echo ${s}
#     # echo ${s.ID}
#     # echo ${s[*]}
#     # echo ${s["ID"]}
#     # echo ${s["ID"]}

# done

# $secrets --query value
# $secrets --query 'value'
# $secrets --query "'value'"
# $secrets --query "[value]"
# $secrets --query "[?value]"
# $secrets --query "[?[value]]"
# $secrets --query "[?[value].value]"

 


# ah=$($secrets --query 'value' --output tsv)
# echo $ah

# $secrets[0].enabled
# for secret in $secrets
#     echo $secret
