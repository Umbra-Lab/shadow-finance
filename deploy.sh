#!/bin/bash

rm -rf build
leo run

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/.env

PROGRAM=$(python3 -c "import json; print(json.load(open('build/program.json'))['program'])")

snarkos developer deploy --network 1 -p $PRIVATE_KEY -q $NODE_URL -b $NODE_URL/testnet/transaction/broadcast --priority-fee 0 --path build $PROGRAM
