#!/bin/sh

set -ex 

echo "Running $0"

bundle exec rake db:migrate
bundle exec rake users:find_all_matches
