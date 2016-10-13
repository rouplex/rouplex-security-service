#!/usr/bin/env bash
./create-certificate-authority.sh
./create-server-keystore.sh
./create-client-keystore.sh
./sign-client-certificate.sh
./create-truststores.sh
./import-client-privatekey-to-keychain.sh
