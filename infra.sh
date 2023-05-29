#!/bin/bash

if [ ! -d "$HOME/mysql" ]; then
  mkdir -p "$HOME/mysql"
fi

if [ ! -d "$HOME/www" ]; then
  mkdir -p "$HOME/app/www"
fi

docker-compose up -d 