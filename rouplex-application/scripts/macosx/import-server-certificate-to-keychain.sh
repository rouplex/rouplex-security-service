#!/usr/bin/env bash
if [ -z "$domain_name" ]; then export domain_name=localhost; fi

if [ -z "$server_keystore_password" ]; then export server_keystore_password=${domain_name}_skp; fi
server_cer=${domain_name}.cer

# Delete previous certificate from keychain
security delete-certificate -c $domain_name

# Import server certificate to keychain
security import $server_cer -k /Users/${USER}/Library/Keychains/login.keychain-db -t cert -P $server_keystore_password