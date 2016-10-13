#!/usr/bin/env bash
domain_name=localhost

server_keystore_password=${domain_name}_skp
server_cer=${domain_name}.cer

# Delete previous certificate from keychain
security delete-certificate -c $domain_name

# Import server certificate to keychain
security import $server_cer -k /Users/${USER}/Library/Keychains/login.keychain-db -t cert -P localhost_skp