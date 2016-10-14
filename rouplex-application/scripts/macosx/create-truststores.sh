#!/usr/bin/env bash
if [ -z "$domain_name" ]; then export domain_name=localhost; fi
if [ -z "$client_name" ]; then export client_name=Monkey; fi

server_keystore_jks=${domain_name}_server_keystore.jks
if [ -z "$server_keystore_password" ]; then export server_keystore_password=${domain_name}_skp; fi
server_truststore_jks=${domain_name}_server_truststore.jks
if [ -z "$server_truststore_password" ]; then export server_truststore_password=${domain_name}_stp; fi

client_truststore_jks=${client_name}_client_truststore.jks
if [ -z "$client_truststore_password" ]; then export client_truststore_password=${client_name}_ctp; fi
server_cer=${domain_name}.cer

# Import CA public certificate into server's truststore
keytool -importcert -keystore $server_truststore_jks -alias ca -file ca-certificate.der -storepass $server_truststore_password -noprompt

# Copy server public certificate into client's truststore
keytool -exportcert -alias $domain_name -file $server_cer -keystore $server_keystore_jks -storepass $server_keystore_password
keytool -importcert -keystore $client_truststore_jks -alias $domain_name -file $server_cer -storepass $client_truststore_password -noprompt
