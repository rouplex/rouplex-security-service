#!/usr/bin/env bash

# this script will set up the everything that does not already exist:
# root-ca, sub-ca, client-credentials, server-credentials

if [ -z "$domain_name" ]; then export domain_name=localhost; fi
if [ -z "$client_name" ]; then export client_name=meme; fi
if [ -z "$organization_name" ]; then export organization_name=Rouplex_Sub_CA_Org_Example; fi
echo "Rouplex --- Using domain_name=$domain_name, client_name=$client_name, organization_name=$organization_name"

root_ca_folder=root-ca
if [ ! -d $root_ca_folder ]
then
    ./create-root-ca.sh
fi

sub_ca_folder=sub-cas/sub-ca-$organization_name
if [ ! -d $sub_ca_folder ]
then
    ./create-sub-ca.sh $organization_name.com $organization_name
fi

server_credentials_folder=server-credentials/$domain_name
if [ ! -d $server_credentials_folder ]
then
    ./create-server-credentials.sh $domain_name $organization_name
fi

client_credentials_folder=client-credentials/$client_name
if [ ! -d $client_credentials_folder ]
then
    ./create-client-credentials.sh $client_name $organization_name
fi

cp root-ca/root-ca.crt ../root-ca.crt
cp sub-cas/sub-ca-$organization_name/$organization_name.crt ../sub-ca.crt
cp server-credentials/$domain_name/$domain_name-$organization_name.p12 ../server-keystore.p12
cp client-credentials/$client_name/$client_name-$organization_name.p12 ../client-keystore.p12

cd ..
rm server-truststore.jks
keytool -importcert -keystore server-truststore.jks -alias sub-ca -storepass truststore -file sub-ca.crt

rm client-truststore.jks
keytool -importcert -keystore client-truststore.jks -alias root-ca -storepass truststore -file root-ca.crt

if [[ $1 == "import" ]]
then
    echo "Rouplex --- Importing client's private key for $client_name and root-ca's public certificate in system's keystore"
    # Import client certificate and private key to keychain
    security import client-keystore.p12 -k /Users/${USER}/Library/Keychains/login.keychain-db -t cert -f pkcs12 -P $client_name

    # Delete previous certificate from keychain
    security delete-certificate -c Rouplex_Root_CA_Org_Example

    # Import server certificate to keychain
    security import root-ca.crt -k /Users/${USER}/Library/Keychains/login.keychain-db -t cert
fi

config_folder=`pwd`

echo "
<Connector
   clientAuth=\"true\" port=\"8088\" minSpareThreads=\"5\" maxSpareThreads=\"75\"
   enableLookups=\"true\" disableUploadTimeout=\"true\"
   acceptCount=\"100\" maxThreads=\"200\"
   scheme=\"https\" secure=\"true\" SSLEnabled=\"true\"
   keystoreFile=\"$config_folder/server-keystore.p12\" keystoreType=\"PKCS12\" keystorePass=\"localhost\"
   truststoreFile=\"$config_folder/server-truststore.jks\" truststoreType=\"JKS\" truststorePass=\"truststore\"
   SSLVerifyClient=\"optional\" SSLEngine=\"on\" SSLVerifyDepth=\"3\" sslProtocol=\"TLS\"
/>"
