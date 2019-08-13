#!/bin/sh

set -ex 

echo "Running $0"

bundle exec rake db:migrate

# add any scripts here that should be run on deploy
