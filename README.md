# KidsClub

## Develop

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
    $ git checkout --track origin/vuefied
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
1. Setup database
    ```
    $ RAILS_ENV=development bin/rails db:create
    $ RAILS_ENV=development bin/rails db:schema:load
    ```

1. Install JS packages
    ```
    $ yarn
    ```

1. If required, copy the matching values in `.env` from Heroku app `vuefied-kidsclub`
    ```
    $ heroku config -sa kidsclub-vuefied
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

#### Jest
for testing vue/js frontend
    ```
    $ yarn run test
    ```

## Deploy

### Prerequisites

1. Access to the Heroku app.
1. [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

### Setup

1. Add the remote, if not already present.
    ```
    $ heroku git:remote --remote vuefied -a vuefied-kidsclub
    ```

### Deploy

1. Push to Heroku
    ```
    $ git push vuefied vuefied:master
    ```
