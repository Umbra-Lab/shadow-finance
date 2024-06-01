#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/.env

log_dir=logs-$(date +"%Y%m%d%H%M")
mkdir ~/.aleo/devnet/$log_dir -p
cd ~/.aleo/devnet

tmux new-session -d -s "devnet" -n "window0"

for validator_index in $(seq 0 3); do
  log_file="$log_dir/validator-$validator_index.log"
  window_index=$((validator_index + index_offset))
  if [ "$validator_index" -eq 0 ]; then
    tmux send-keys -t "devnet:window0" "snarkos start --private-key $PRIVATE_KEY --nodisplay --dev $validator_index --allow-external-peers --dev-num-validators 4 --validator --logfile $log_file --metrics" C-m
  else
    tmux new-window -t "devnet:$window_index" -n "window$validator_index"
    tmux send-keys -t "devnet:window$validator_index" "snarkos start --nodisplay --dev $validator_index --allow-external-peers --dev-num-validators 4 --validator --logfile $log_file" C-m
  fi
done

tmux attach-session -t "devnet"
