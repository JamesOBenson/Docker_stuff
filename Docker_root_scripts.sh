#!/bin/bash
# Docker_root_scripts.sh

curl -L https://github.com/docker/compose/releases/download/1.6.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# uname -m: x86_64
# uname -s: linux

#version="Linux-x86_64"
#curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r ".assets[] | select(.name | test(\"${version}\")) | .browser_download_url"  
