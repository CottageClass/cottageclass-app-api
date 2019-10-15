#! /bin/bash

set -ex
echo "running $0"

yarn lint
yarn test
rspec
