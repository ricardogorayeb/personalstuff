#!/bin/bash
USERNAME='username'
SECRET_ENGINE=linuxservers
ROLE=vault_role

unset VAULT_TOKEN
export VAULT_ADDR='https://vault.address.com'


export VAULT_TOKEN=$(vault login -method=ldap -token-only username=$USERNAME)
    
vault write -field=signed_key $SECRET_ENGINE/sign/$ROLE public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub

