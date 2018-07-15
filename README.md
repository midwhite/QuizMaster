# QuizMaster

Server Side for [quiz-master-app](https://github.com/midwhite/quiz-master-app)

## Build Setup
### setup application

```bash
# clone project
$ git clone git@github.com:midwhite/QuizMaster.git

# install dependencies
$ bundle install --path vendor/bundle
```

### install and init mysql
```bash
$ brew install mysql@5.6
$ brew link --force mysql@5.6
$ brew services mysql@5.6 start
```

### set environment variables
Set environment variables below (You can use .env file):

- LOCAL_DATABASE_PASSWORD (if you need password to login local mysql)
- SECRET_KEY_BASE (use the command below to set)

```bash
$ echo SECRET_KEY_BASE=`bundle exec rails secret` >> .env
```

```bash
# setup database
$ bundle exec rails db:create
$ bundle exec rails db:migrate

# run tests
$ bundle exec rspec

# build for development
$ bundle exec rails s
```
