#!/usr/bin/env bash
domain_name=localhost
client_name=Monkey

server_keystore_jks=${domain_name}_server_keystore.jks
server_keystore_password=${domain_name}_skp
server_truststore_jks=${domain_name}_server_truststore.jks
server_truststore_password=${domain_name}_stp

client_truststore_jks=${client_name}_client_truststore.jks
client_truststore_password=${client_name}_ctp
server_cer=${domain_name}.cer

# Import CA public certificate into server's truststore
keytool -importcert -keystore $server_truststore_jks -alias ca -file ca-certificate.der -storepass $server_truststore_password -noprompt

# Copy server public certificate into client's truststore
keytool -exportcert -alias $domain_name -file $server_cer -keystore $server_keystore_jks -storepass $server_keystore_password
keytool -importcert -keystore $client_truststore_jks -alias $domain_name -file $server_cer -storepass $client_truststore_password -noprompt
