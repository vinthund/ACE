#! /usr/bin/env bash
echo -e "gzipping $1 to $1.gz\n"
gzip -k $1
echo "moving $1.gz to /usr/share/man/man$2"
sudo cp "$1.gz" "/user/share/man/man$2/"

