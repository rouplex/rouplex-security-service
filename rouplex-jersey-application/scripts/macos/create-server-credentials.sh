#!/usr/bin/env bash
if [ -z "$1" ]
then
    echo "Please supply the domain name for the server certificate"
    exit 1
fi
domain_name=$1

if [ -z "$2" ]
then
    echo "Please supply the organization name (of self -- which should be the name of the sub-ca's)"
    exit 1
fi
organization_name=$2

mkdir server-certs
pushd server-certs
mkdir $domain_name
pushd $domain_name

echo Creating private key for $domain_name
openssl genrsa -aes128 -passout pass:$domain_name -out $domain_name.key 2048

echo "[req]
prompt = no
distinguished_name = dn
req_extensions = ext
input_password = $domain_name

[dn]
CN = $domain_name
O = $organization_name
C = US

[ext]
subjectAltName = DNS:www.$domain_name,DNS:$domain_name" > server.conf

echo Creating csr for $domain_name
openssl req -new -config server.conf -key $domain_name.key -out $domain_name-$organization_name.csr

popd
popd

echo Signing certificate by sub-ca-$organization_name
pushd sub-cas/sub-ca-$organization_name
./sign-server-csr.sh ../../server-certs/$domain_name/$domain_name-$organization_name.csr ../../server-certs/$domain_name/$domain_name-$organization_name.crt
popd
