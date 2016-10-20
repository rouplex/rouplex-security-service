#!/usr/bin/env bash
if [ -z "$domain_name" ]; then export domain_name=localhost; fi
if [ -z "$client_name" ]; then export client_name=meme; fi
if [ -z "$organization_name" ]; then export organization_name=Rouplex_Sub_CA_Example; fi

cp server-credentials/$domain_name/$domain_name-$organization_name.p12 ../server-keystore.p12
cp client-credentials/$client_name/$client_name-$organization_name.p12 ../client-keystore.p12
cp sub-cas/sub-ca-$organization_name/$organization_name.crt ../sub-ca.crt

cd ..
rm server-truststore.jks
keytool -importcert -keystore server-truststore.jks -alias sub-ca -storepass truststore -file sub-ca.crt
rm sub-ca.crt

config_folder=`pwd`

echo "
<Connector
   clientAuth=\"true\" port=\"8088\" minSpareThreads=\"5\" maxSpareThreads=\"75\"
   enableLookups=\"true\" disableUploadTimeout=\"true\"
   acceptCount=\"100\" maxThreads=\"200\"
   scheme=\"https\" secure=\"true\" SSLEnabled=\"true\"
   keystoreFile=\"$config_folder/server-keystore.p12\"
   keystoreType=\"PKCS12\" keystorePass=\"localhost\"
   truststoreFile=\"$config_folder/server-truststore.jks\"
   truststoreType=\"JKS\" truststorePass=\"truststore\"
   SSLVerifyClient=\"require\" SSLEngine=\"on\" SSLVerifyDepth=\"2\" sslProtocol=\"TLS\"
/>"

