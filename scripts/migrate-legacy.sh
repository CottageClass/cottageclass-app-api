#! /bin/bash
# this script is for testing migrations of legacy (pre-devise) users into devise.
# There's no reason it should be useful in its current state after the March 2019 transition

set -ex
echo $PWD
git checkout .
git clean -fd
git checkout master
git pull
rm Gemfile.lock
bundle install
# rails db:drop db:create db:migrate

# set the evnironment to development in the database so we don't trigger any protections
bin/rails db:environment:set RAILS_ENV=development

pg_restore --verbose --clean --no-acl --no-owner -h localhost -U cottageclassrails -d cottage_class_development ~/Downloads/latest.dump || true
rails s &

# wait for the rails server to start
sleep 5

rails_pid=`cat tmp/pids/server.pid`

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"first_name": "ari", "last_name": "kaka", "email": "ari.kardasis+101@gmail.com", "password": "dummy101"}' \
  http://localhost:3000/auth/register

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"first_name": "ari", "last_name": "kaka", "email": "ari.kardasis+102@gmail.com", "password": "dummy102"}' \
  http://localhost:3000/auth/register

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"first_name": "ari", "last_name": "kaka", "email": "ari.kardasis+103@gmail.com", "password": "dummy103"}' \
  http://localhost:3000/auth/register

kill -KILL $rails_pid

git checkout .
git clean -fd
git checkout migrating-old-users
yarn
bundle install
bundle exec rake db:migrate
hivemind -p 3000 Procfile.dev
