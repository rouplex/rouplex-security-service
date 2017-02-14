#!/usr/bin/env bash

if [[ $1 == "optional" ]]
then
    echo "Rouplex --- Testing with server side authentication only"
    curl -X GET --header 'Accept: application/json' 'https://localhost:8088/rouplex/security/ping' --cacert ../sub-ca.crt
    if [[ $? != 0 ]]; then echo; echo "Rouplex --- Test failed"; exit 1; fi
elif [[ $1 == "required" ]]
then
    if [ -z "$client_name" ]; then export client_name=meme; fi

    echo "Rouplex --- Testing with mutual authentication, assuming client password is '$client_name' (no quotes)"
    curl -X GET --header 'Accept: application/json' 'https://localhost:8088/rouplex/security/ping' --cert ../client-keystore.p12:$client_name --cacert ../sub-ca.crt
    if [[ $? != 0 ]]; then echo; echo "Rouplex --- Test failed"; exit 1; fi
else
    echo "Rouplex --- Test failed. Please specify argument from this set {optional, required} depending on client auth you have on connector"
    exit 1
fi

echo; echo "Rouplex --- Test passed"
