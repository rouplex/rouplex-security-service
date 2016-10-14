#!/usr/bin/env bash
if [ -z "$domain_name" ]; then export domain_name=localhost; fi

server_keystore_jks=${domain_name}_server_keystore.jks
server_truststore_jks=${domain_name}_server_truststore.jks

current_folder=`pwd`

echo "
<Connector
   clientAuth=\"true\" port=\"8443\" minSpareThreads=\"5\" maxSpareThreads=\"75\"
   enableLookups=\"true\" disableUploadTimeout=\"true\"
   acceptCount=\"100\" maxThreads=\"200\"
   scheme=\"https\" secure=\"true\" SSLEnabled=\"true\"
   keystoreFile=\"${current_folder}/${server_keystore_jks}\"
   keystoreType=\"JKS\" keystorePass=\"localhost_skp\"
   truststoreFile=\"${current_folder}/${server_truststore_jks}\"
   truststoreType=\"JKS\" truststorePass=\"localhost_stp\"
   SSLVerifyClient=\"optional\" SSLEngine=\"on\" SSLVerifyDepth=\"2\" sslProtocol=\"TLS\"
/>" > connector-snippet.xml
