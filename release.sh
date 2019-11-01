#!/bin/sh

set -ex 

echo "Running $0"

bundle exec rake db:migrate

bundle exec rake push:create_rpush_apps

# add any scripts here that should be run on deploy
