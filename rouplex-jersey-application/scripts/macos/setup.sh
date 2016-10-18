#!/usr/bin/env bash

pushd root-ca
./setup.sh
popd

pushd sub-ca
./setup.sh
popd

