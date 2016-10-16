#!/usr/bin/env bash
if [ -z "$client_name" ]; then export client_name=Monkey; fi

client_keystore_jks=${client_name}_client_keystore.jks
client_keystore_pfx=${client_name}_client_keystore.pfx
if [ -z "$client_keystore_password" ]; then export client_keystore_password=${client_name}_ckp; fi

# Export client certificate and privatekey to pfx format
keytool -importkeystore -srckeystore $client_keystore_jks -srcstoretype JKS -srcstorepass $client_keystore_password -srcalias $client_name -destkeystore $client_keystore_pfx -deststoretype PKCS12 -deststorepass $client_keystore_password -destalias $client_name

# Delete keypair from keychain
security delete-certificate -c $client_name

# Import client certificate and privatekey to keychain
security import $client_keystore_pfx -k /Users/${USER}/Library/Keychains/login.keychain-db -t cert -f pkcs12 -P $client_keystore_password