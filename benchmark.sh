#!/bin/bash

source="https://raw.githubusercontent.com/griffin8828/deenie"
 

# go to root
cd

wget $source/debian7/bench.sh -O - -o /dev/null|bash
