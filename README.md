# QuizMaster

QuizMaster for Server Side

## Build Setup

### setup application

``` bash
# clone project
$ git clone git@github.com:midwhite/QuizMaster.git

# install dependencies
$ bundle install --path vendor/bundle
```

### set environment variables
Set environment variables below (You can use .env file):

- LOCAL_DATABASE_PASSWORD (if you need password to use local mysql)

``` bash
# setup database
$ bundle exec rails db:create
$ bundle exec rails db:migrate

# build for development
$ bundle exec rails s

# run tests
$ bundle exec rspec
```
