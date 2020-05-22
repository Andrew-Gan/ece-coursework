#!/usr/bin/bash

git pull

cd ../../os
make clean
make
cd ../apps/prio_test
make clean
make
make run > output
less output
