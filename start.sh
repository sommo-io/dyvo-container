#!/bin/bash

# echo "conda activate py37" >> ~/.bashrc
# source ~/.bashrc

echo "pod started"

if [[ $PUBLIC_KEY ]]
then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cd ~/.ssh
    echo $PUBLIC_KEY >> authorized_keys
    chmod 700 -R ~/.ssh
    cd /
    service ssh start
fi

cd workspace
git clone https://$GH_ACCESS_TOKEN@github.com/No-Code-No-Problem/dyvo-sd-setup
cd dyvo-sd-setup
export DB_DIR=$(pwd)/dyvo-sd
export PIP_CACHE_DIR=$(pwd)/pip_cache
export TRANSFORMERS_CACHE=$(pwd)/transformers-cache
bash -l start.sh

bash -c "sleep inf"
# bash -c "cd workspace; git clone https://$GH_ACCESS_TOKEN@github.com/No-Code-No-Problem/dyvo-sd-setup; cd dyvo-sd-setup; sh start.sh; sleep infinity"