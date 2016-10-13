#!/usr/bin/env bash

# Create CA keypair and public certificate
openssl req -config /System/Library/OpenSSL/openssl.cnf -new -x509 -subj "/C=US/ST=CA/L=San Jose/O=Certification Authority/OU=Digital Signatures/CN=digisign@certauth.org" -keyout ca-privatekey.pem -out ca-certificate.pem -days 365

# Convert CA public certificate in der format
openssl x509 -in ca-certificate.pem -out ca-certificate.der -outform der