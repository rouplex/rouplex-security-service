#!/usr/bin/env bash
if [ -z "$domain_name" ]; then export domain_name=localhost; fi

if [ -z "$organization_name" ]; then export organization_name=MyOrg; fi

server_truststore_jks=${domain_name}_server_truststore.jks
server_truststore_password=${domain_name}_stp

current_folder=`pwd`

echo "
<Connector
   clientAuth=\"true\" port=\"8088\" minSpareThreads=\"5\" maxSpareThreads=\"75\"
   enableLookups=\"true\" disableUploadTimeout=\"true\"
   acceptCount=\"100\" maxThreads=\"200\"
   scheme=\"https\" secure=\"true\" SSLEnabled=\"true\"
   keystoreFile=\"$current_folder/server.p12\"
   keystoreType=\"PKCS12\" keystorePass=\"server\"
   truststoreType=\"$current_folder/server-truststore.jks\"
   truststoreType=\"JKS\" truststorePass=\"server\"
   SSLVerifyClient=\"optional\" SSLEngine=\"on\" SSLVerifyDepth=\"2\" sslProtocol=\"TLS\"
/>"
