#!/usr/bin/env bash

echo Creating sub directories
mkdir certs db private
chmod 700 private
touch db/index
openssl rand -hex 16  > db/serial
echo 1001 > db/crlnumber

echo Creating Sub CA private key and csr
openssl req -new -config sub-ca.conf -out sub-ca.csr -keyout private/sub-ca.key

echo Signing the csr at root
pushd ../root-ca
./sign-sub-ca-csr.sh ../sub-ca/sub-ca.csr ../sub-ca/sub-ca.crt
popd

echo Importing the signed certificate


# delete sub-ca.csr maybe?

