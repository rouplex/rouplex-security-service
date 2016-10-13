#!/usr/bin/env bash
domain_name=localhost

server_keystore_jks=${domain_name}_server_keystore.jks
server_keystore_password=${domain_name}_skp

# Create keypair and certificate for the domain
keytool -genkeypair -alias $domain_name -keyalg RSA -dname 'CN='$domain_name',OU=Application Development,O=dajt.com,L=San Jose,S=CA,C=US' -keypass $server_keystore_password -keystore $server_keystore_jks -storepass $server_keystore_password
