#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/.env

log_dir=logs-$(date +"%Y%m%d%H%M")
mkdir ~/.aleo/devnet/$log_dir -p
cd ~/.aleo/devnet

tmux new-session -d -s "devnet" -n "window0"

for validator_index in $(seq 0 3); do
  log_file="$log_dir/validator-$validator_index.log"
  tmux new-window -t "devnet:$validator_index" -n "window$validator_index"
  tmux send-keys -t "devnet:window$validator_index" "snarkos start --private-key $PRIVATE_KEY --dev $validator_index --validator --logfile $log_file" C-m
done

tmux attach-session -t "devnet"
