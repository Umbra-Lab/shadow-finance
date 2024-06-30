#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/.env

PROGRAM=$(python3 -c "import json; print(json.load(open('build/program.json'))['program'])")

snarkos developer execute --network 1 --private-key $PRIVATE_KEY --priority-fee 0 --query $NODE_URL --broadcast $NODE_URL/testnet/transaction/broadcast $PROGRAM "$@"
