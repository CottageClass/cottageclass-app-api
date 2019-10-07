#!/bin/sh

set -ex 

echo "Running $0"

bundle exec rake db:migrate

bundle exec rake places:update_place_details

# add any scripts here that should be run on deploy
