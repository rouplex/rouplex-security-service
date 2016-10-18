#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo "Please supply the csr (input -- certificate to sign) file"
    exit 1
fi

if [ -z "$2" ]
then
    echo "Please supply the crt (output -- signed certificate) file"
    exit 1
fi

openssl ca -config sub-ca.conf -in $1 -out $2 -extensions client_ext
