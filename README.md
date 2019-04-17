# KidsClub

## Development
This repo contains the rails app which serves up the Vue app. 
The Vue app is contained in the ./src folder.

The `develop` branch should be used for development.  `Master` should be used for releases (staging and production).

### Prerequisites

1. PostgreSQL, [Yarn](https://yarnpkg.com/en/), Git, [RVM](https://rvm.io/), [HiveMinds](https://github.com/DarthSim/hivemind)
1. Ruby 2.5.3
    ```
    $ rvm install 2.5.3
    ```
1. Recommended: install [Watchman](https://facebook.github.io/watchman) for jest testing 
    ```bash
    $ brew install watchman
    ```


### Install

1. Get the code
    ```
    $ git clone git@github.com:CottageClass/cottageclass-app-api.git KidsClub
    $ cd KidsClub
    $ git checkout --track origin/develop
    ```

1. Install gems
    ```
    $ bundle
    ```

1. Create your copy of .env
    ```
    $ cp .env.sample .env
    ```

1. Update .env with database user/password.
You can choose your username and password and Postgres will use those to create the test and development databases.
1. Setup database
    ```
    $ RAILS_ENV=development bin/rails db:create
    $ RAILS_ENV=development bin/rails db:schema:load
    ```

1. Install JS packages
    ```
    $ yarn
    ```

1. If required, copy the matching values in `.env` from Heroku app `kidsclub-staging`
    ```
    $ heroku config -sa kidsclub-staging
    ```

### Run

1. Start the rails server and the webpack dev server with
    ```
    hivemind -p 3000 Procfile.dev
    ```

1. Visit [http://cottageclass.ngrok.io/](http://cottageclass.ngrok.io/).  Or use your own ngrok

## Test

### Setup

1. Setup database
    ```
    $ RAILS_ENV=test bin/rails db:create
    $ RAILS_ENV=test bin/rails db:schema:load
    ```

### Run

#### RSpec
for testing rails backend
    ```
    $ bin/rspec -fd
    ```
you can also watch with 
    ```
    $ guard
    ```


#### Jest
for testing vue/js frontend.  This will run watch tests.
    ```
    $ yarn run test
    ```
and to watch : 
    ```
    $ yarn run test-watch
    ```

## Logs
We have a nice logging util that is included in all Vue components via a global mixin.  To use it: 
`this.log(msg)`,`this.debug(msg)`,`this.error(msg)`

## Deployment
All PR's to `develop` on github will result in review apps in the [heroku pipeline](https://dashboard.heroku.com/pipelines/f1618cba-fac9-4a02-9dee-4ddf2bc31ba6).  The stagin app is automatically deployed from `master` and the production app has to be manually deployed on the heroku dashboard.
