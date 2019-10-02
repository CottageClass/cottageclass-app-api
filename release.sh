#!/bin/sh

set -ex 

echo "Running $0"

bundle exec rake db:migrate

bundle exec rake users:create_user_places

# add any scripts here that should be run on deploy
