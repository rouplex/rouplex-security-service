#!/usr/bin/env bash
client_name=Monkey

client_keystore_jks=${client_name}_client_keystore.jks
client_keystore_password=${client_name}_ckp

# Create keypair and certificate for the client
keytool -genkeypair -alias $client_name -keyalg RSA -dname 'CN='$client_name',OU=Some Org Unit,O=Some Org,L=Some Locality,S=Some State,C=Some Country' -keystore $client_keystore_jks -storepass $client_keystore_password
