#! /bin/bash

set -ex

rspec
yarn test
yarn lint
