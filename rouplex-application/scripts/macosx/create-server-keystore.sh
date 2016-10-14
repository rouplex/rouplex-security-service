#!/usr/bin/env bash
if [ -z "$domain_name" ]; then export domain_name=localhost; fi

server_keystore_jks=${domain_name}_server_keystore.jks
if [ -z "$server_keystore_password" ]; then export server_keystore_password=${domain_name}_skp; fi

# Create keypair and certificate for the domain
keytool -genkeypair -alias $domain_name -keyalg RSA -dname 'CN='$domain_name',OU=Application Development,O=dajt.com,L=San Jose,S=CA,C=US' -keypass $server_keystore_password -keystore $server_keystore_jks -storepass $server_keystore_password
