#!/bin/bash

getopts ":d" dev
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/.env

if [ $dev = "d" ]; then
    snarkos developer deploy --private-key $PRIVATE_KEY --query http://127.0.0.1:3033/ --priority-fee 0 --broadcast http://127.0.0.1:3033/testnet3/transaction/broadcast --path build $1
else
    snarkos developer deploy --private-key $PRIVATE_KEY --query $TESTNET --priority-fee 0 --broadcast $TESTNET/testnet3/transaction/broadcast --path build $1
fi
