#!/usr/bin/env bash

echo Creating directory structure
mkdir root-ca
cp -r templates/root-ca .

pushd root-ca
mkdir certs db private
chmod 700 private
touch db/index
openssl rand -hex 16  > db/serial
echo 1001 > db/crlnumber

echo Creating Root CA private key and csr
openssl req -new -config root-ca.conf -out root-ca.csr -keyout private/root-ca.key

echo Self signing the csr
openssl ca -selfsign -config root-ca.conf -in root-ca.csr -out root-ca.crt -extensions ca_ext
# delete root-ca.csr maybe?

popd
