#!/usr/bin/env bash
if [ -z "$client_name" ]; then export client_name=Monkey; fi

client_keystore_jks=${client_name}_client_keystore.jks
if [ -z "$client_keystore_password" ]; then client_keystore_password=${client_name}_ckp; fi

# Create keypair and certificate for the client
keytool -genkeypair -alias $client_name -keyalg RSA -dname 'CN='$client_name',OU=Some Org Unit,O=Some Org,L=Some Locality,S=Some State,C=Some Country' -keystore $client_keystore_jks -storepass $client_keystore_password
