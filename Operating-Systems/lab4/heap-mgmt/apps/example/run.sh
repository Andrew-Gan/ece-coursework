#!/usr/bin/bash
git pull


cd ../..
cd os
make clean
make

cd ..
cd apps/example
make clean
make
make run