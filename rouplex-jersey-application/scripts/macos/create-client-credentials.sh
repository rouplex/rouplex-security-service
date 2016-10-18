#!/usr/bin/env bash
if [ -z "$1" ]
then
    echo "Please supply the common name for the client"
    exit 1
fi

client_name=$1
mkdir client-credentials client-credentials/${client_name}
pushd client-credentials/${client_name}

echo Creating private key for ${client_name}
openssl genrsa -aes128 -passout pass:${client_name} -out ${client_name}.key 2048

echo "[req]
prompt = no
distinguished_name = dn
input_password = ${client_name}

[dn]
CN = ${client_name}
O = Rouplex
L = San Jose
ST = CA
C = US" > ${client_name}.conf

echo Creating csr for ${client_name}
openssl req -new -config ${client_name}.conf -key ${client_name}.key -out ${client_name}.csr
popd

echo Signing certificate by sub-ca
pushd sub-ca
./sign-client-csr.sh ../client-credentials/${client_name}/${client_name}.csr ../client-credentials/${client_name}/${client_name}.crt
popd


#cd sub-ca
#openssl ca -config ../sub-ca.conf -in ../client-credentials/${client_name}/${client_name}.csr -out ../client-credentials/${client_name}/${client_name}.crt -extensions client_ext

#openssl ca -config sub-ca.conf -in client-credentials/${client_name}/${client_name}.csr -out client-credentials/${client_name}/${client_name}.crt -extensions client_ext
