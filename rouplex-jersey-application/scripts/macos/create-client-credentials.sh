#!/usr/bin/env bash
if [ -z "$1" ]
then
    echo "Please supply the client name (someonw@somewhere.com)"
    exit 1
fi
client_name=$1

if [ -z "$2" ]
then
    echo "Please supply the client's organization name"
    exit 1
fi
organization_name=$2

mkdir client-certs
pushd client-certs
mkdir $client_name
pushd $client_name

echo Creating private key for $client_name
openssl genrsa -aes128 -passout pass:$client_name -out $client_name.key 2048

echo "[req]
prompt = no
distinguished_name = dn
input_password = $client_name

[dn]
CN = $client_name
O = $organization_name
C = US" > client.conf

echo Creating csr for $client_name
openssl req -new -config client.conf -key $client_name.key -out $client_name-$organization_name.csr

popd
popd

echo Signing certificate by sub-ca-$organization_name
pushd sub-cas/sub-ca-$organization_name
./sign-client-csr.sh ../../client-certs/$client_name/$client_name-$organization_name.csr ../../client-certs/$client_name/$client_name-$organization_name.crt
popd
