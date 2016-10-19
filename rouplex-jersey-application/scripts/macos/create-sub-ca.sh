#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo "Please supply the sub-ca organization name"
    exit 1
fi
organization_name=$1

if [ -z "$2" ]
then
    echo "Please supply the sub-ca organization domain suffix"
    exit 1
fi
domain_suffix=$2

echo Creating directory structure
mkdir sub-cas
pushd sub-cas

mkdir sub-ca-$organization_name
pushd sub-ca-$organization_name

mkdir certs db private
chmod 700 private
touch db/index
openssl rand -hex 16  > db/serial
echo 1001 > db/crlnumber

echo Creating ssl config file
home=.
echo "[default]
name                    = $organization_name
domain_suffix           = $domain_suffix
aia_url                 = http://$organization_name.$domain_suffix/$organization_name.crt
crl_url                 = http://$organization_name.$domain_suffix/$organization_name.crl
ocsp_url                = http://ocsp.$organization_name.$domain_suffix:9081
default_ca              = ca_default
name_opt                = utf8,esc_ctrl,multiline,lname,align

[ca_dn]
countryName             = "US"
organizationName        = $organization_name
commonName              = Certificate Signer


[ca_default]
home                    = $home
database                = $home/db/index
serial                  = $home/db/serial
crlnumber               = $home/db/crlnumber
certificate             = $home/$organization_name.crt
private_key             = $home/private/$organization_name.key
RANDFILE                = $home/private/random
new_certs_dir           = $home/certs
unique_subject          = no
copy_extensions         = copy
default_days            = 365
default_crl_days        = 30
default_md              = sha256
policy                  = policy_c_o_match

[policy_c_o_match]
countryName             = match
stateOrProvinceName     = optional
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional


[req]
default_bits            = 4096
encrypt_key             = yes
default_md              = sha256
utf8                    = yes
string_mask             = utf8only
prompt                  = no
distinguished_name      = ca_dn
req_extensions          = ca_ext

[ca_ext]
basicConstraints        = critical,CA:true
keyUsage                = critical,keyCertSign,cRLSign
subjectKeyIdentifier    = hash


[sub_ca_ext]
authorityInfoAccess     = @issuer_info
authorityKeyIdentifier  = keyid:always
basicConstraints        = critical,CA:true,pathlen:0
crlDistributionPoints   = @crl_info
extendedKeyUsage        = clientAuth,serverAuth
keyUsage                = critical,keyCertSign,cRLSign
nameConstraints         = @name_constraints
subjectKeyIdentifier    = hash

[crl_info]
URI.0                   = $crl_url

[issuer_info]
caIssuers;URI.0         = $aia_url
OCSP;URI.0              = $ocsp_url

[name_constraints]
#permitted;DNS.0=rouplex.com
#permitted;DNS.1=rouplex.org
#excluded;IP.0=0.0.0.0/0.0.0.0
#excluded;IP.1=0:0:0:0:0:0:0:0/0:0:0:0:0:0:0:0


[ocsp_ext]
authorityKeyIdentifier  = keyid:always
basicConstraints        = critical,CA:false
extendedKeyUsage        = OCSPSigning
keyUsage                = critical,digitalSignature
subjectKeyIdentifier    = hash


[server_ext]
authorityInfoAccess     = @issuer_info
authorityKeyIdentifier  = keyid:always
basicConstraints        = critical,CA:false
crlDistributionPoints   = @crl_info
extendedKeyUsage        = clientAuth,serverAuth
keyUsage                = critical,digitalSignature,keyEncipherment
subjectKeyIdentifier    = hash

[client_ext]
authorityInfoAccess     = @issuer_info
authorityKeyIdentifier  = keyid:always
basicConstraints        = critical,CA:false
crlDistributionPoints   = @crl_info
extendedKeyUsage        = clientAuth
keyUsage                = critical,digitalSignature
subjectKeyIdentifier    = hash
" > sub-ca.conf


echo Creating Sub CA private key and csr
openssl req -new -config sub-ca.conf -out $organization_name.csr -keyout private/$organization_name.key

echo Signing the csr at root
pushd ../../root-ca
./sign-sub-ca-csr.sh ../sub-cas/sub-ca-$organization_name/$organization_name.csr ../sub-cas/sub-ca-$organization_name/$organization_name.crt
popd

echo Importing the signed certificate
# delete ${sub_ca}.csr maybe?

popd
popd

cp templates/sub-ca/*.sh sub-cas/sub-ca-$organization_name
