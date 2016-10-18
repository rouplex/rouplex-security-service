#!/usr/bin/env bash
if [ -z "$1" ]
then
    echo "Please supply the domain name for the server certificate"
    exit 1
fi

domain_name=$1
mkdir server-credentials server-credentials/${domain_name}
pushd server-credentials/${domain_name}

echo Creating private key for ${domain_name}
openssl genrsa -aes128 -passout pass:${domain_name} -out ${domain_name}.key 2048

echo "[req]
prompt = no
distinguished_name = dn
req_extensions = ext
input_password = ${domain_name}

[dn]
CN = ${domain_name}
emailAddress = admin@${domain_name}
O = Rouplex
L = San Jose
ST = CA
C = US

[ext]
subjectAltName = DNS:www.${domain_name},DNS:${domain_name}" > ${domain_name}.conf

echo Creating csr for ${domain_name}
openssl req -new -config ${domain_name}.conf -key ${domain_name}.key -out ${domain_name}.csr
popd

echo Signing certificate by sub-ca
pushd sub-ca
./sign-server-csr.sh ../server-credentials/${domain_name}/${domain_name}.csr ../server-credentials/${domain_name}/${domain_name}.crt
popd


#cd sub-ca
#openssl ca -config ../sub-ca.conf -in ../server-credentials/${domain_name}/${domain_name}.csr -out ../server-credentials/${domain_name}/${domain_name}.crt -extensions server_ext

#openssl ca -config sub-ca.conf -in server-credentials/${domain_name}/${domain_name}.csr -out server-credentials/${domain_name}/${domain_name}.crt -extensions server_ext
