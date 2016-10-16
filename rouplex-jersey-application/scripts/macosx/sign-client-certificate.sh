#!/usr/bin/env bash
if [ -z "$client_name" ]; then export client_name=Monkey; fi

client_keystore_jks=${client_name}_client_keystore.jks
if [ -z "$client_keystore_password" ]; then export client_keystore_password=${client_name}_ckp; fi
client_csr=${client_name}.csr
client_cer=${client_name}.cer

# Create certificate signing request for client certificate
keytool -certreq -keystore $client_keystore_jks -alias $client_name -storepass $client_keystore_password -keyalg rsa -file $client_csr

# Sign the csr
openssl x509 -req -CA ca-certificate.pem -CAkey ca-privatekey.pem -in $client_csr -out $client_cer -days 365 -CAcreateserial

# Import rootca
keytool -import -keystore $client_keystore_jks -file ca-certificate.pem -alias rootca -storepass $client_keystore_password

# Import the signed certificate
keytool -import -keystore $client_keystore_jks -storepass $client_keystore_password -file $client_cer -alias $client_name
