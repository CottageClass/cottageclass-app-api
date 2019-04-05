#! /bin/bash

set -ex

rspec
jest --config ./jest.conf.js
