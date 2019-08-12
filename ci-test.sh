#! /bin/bash

set -ex
echo "running $0"

rspec
yarn test
yarn lint
