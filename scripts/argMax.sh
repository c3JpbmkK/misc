#!/usr/bin/env bash

rm .env 2>/dev/null || printf "" 

Upper=${1:-1000}
echo Using $Upper additional env vars
for i in $(seq 1 $Upper)
do
	echo export Var$i=$i >> .env
done

echo "Sourcing .env"
. .env
echo "env currently at $(env | wc -c) characters"

echo "Creating new folder (invoking execve)"
mkdir -p deleteme
echo "Deleting new folder (invoking execve)"
rmdir deleteme

rm .env
