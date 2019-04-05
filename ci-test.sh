#! /bin/bash

set -ex

rspec
./node_modules/.bin/jest --config ./jest.conf.js
