#!/bin/bash

echo ${SSH_PRIV_KEY}|base64 -d > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

echo "[user]" > /root/.gitconfig
echo "	name = Christian Hunter" >> /root/.gitconfig 
echo "	email = christian.hunter@kreuzwerker.de" >> /root/.gitconfig

exec $@