#!/usr/bin/env bash
client_name=Monkey

client_keystore_jks=${client_name}_client_keystore.jks
client_keystore_pfx=${client_name}_client_keystore.pfx
client_keystore_password=${client_name}_ckp

# Export client certificate and privatekey to pfx format
keytool -importkeystore -srckeystore $client_keystore_jks -srcstoretype JKS -srcstorepass $client_keystore_password -srcalias $client_name -destkeystore $client_keystore_pfx -deststoretype PKCS12 -deststorepass $client_keystore_password -destalias $client_name

# Import client certificate and privatekey to keychain
security import $client_keystore_pfx -k /Users/${USER}/Library/Keychains/login.keychain-db -t cert -f pkcs12 -P $client_keystore_password