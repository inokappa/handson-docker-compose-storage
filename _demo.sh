#!/bin/bash

which unzip
if [ ! $? == "0" ];then
  echo "please install unzip(sudo apt-get install unzip)"
  exit 1
else
  if [ ! -f ./consul-template ];then
    wget https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip
    unzip consul-template_0.14.0_linux_amd64.zip
  fi

  docker build -f Dockerfile.app -t hands-on-app .
  docker build -f Dockerfile.haproxy -t hands-on-haproxy .
  
  # rm consul-template_0.14.0_linux_amd64.zip
  # rm consul-template
  
  docker-compose -f docker-compose.yml.v1 up -d
fi
