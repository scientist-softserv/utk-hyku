[![Build Status](https://travis-ci.org/projecthydra-labs/lerna.svg)](https://travis-ci.org/projecthydra-labs/lerna)
[![Coverage Status](https://coveralls.io/repos/projecthydra-labs/lerna/badge.svg?branch=master&service=github)](https://coveralls.io/github/projecthydra-labs/lerna?branch=master)
[![Stories in Ready](https://badge.waffle.io/projecthydra-labs/lerna.png?label=ready&title=Ready)](https://waffle.io/projecthydra-labs/lerna)

# Hydra-in-a-Box Repository App

Codename: Lerna

## Running the stack

### For development

```bash
$ solr_wrapper
$ fcrepo_wrapper
$ postgres -D ./db/postgres
$ redis-server /usr/local/etc/redis.conf
$ bin/setup
$ bundle exec rails server
```

### On AWS

AWS CloudFormation templates for the Lerna stack are available in a separate repository:

https://github.com/hybox/aws

### With Docker

We distribute a `docker-compose.yml` configuration for running the Lerna stack and application using docker. Once you have [docker](https://docker.com) installed and running, launch the stack using e.g.:

```bash
$ docker-compose up -d
```

## Switching accounts

The recommend way to switch your current session from one account to another is by doing:

```ruby
AccountElevator.switch!('repo.example.com')
```

## Development Dependencies

### Postgres

Hydra-in-a-Box supports multitenancy using the `apartment` gem. `apartment` works best with a postgres database.

## Importing
### from CSV:

```bash
$ ./bin/import_from_csv localhost spec/fixtures/csv/gse_metadata.csv ../lerna-objects
```

### from purl:

```bash
$ ./bin/import_from_purl ../lerna-objects bc390xk2647 bc402fk6835 bc483gc9313
```
