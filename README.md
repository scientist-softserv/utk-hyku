[![Build Status](https://travis-ci.org/projecthydra-labs/hybox.svg)](https://travis-ci.org/projecthydra-labs/hybox)
[![Coverage Status](https://coveralls.io/repos/projecthydra-labs/hybox/badge.svg?branch=master&service=github)](https://coveralls.io/github/projecthydra-labs/hybox?branch=master)
[![Stories in Ready](https://badge.waffle.io/projecthydra-labs/hybox.png?label=ready&title=Ready)](https://waffle.io/projecthydra-labs/hybox)
# hybox
Hydra-in-a-Box


## Switching accounts

The recommend way to switch your current session from one account to another is by doing:

```ruby
Account.use_account!('repo.example.com')
```

## Development Dependencies

### Postgres

Hydra-in-a-Box supports multitenancy using the `apartment` gem. `apartment` works best with a postgres database.


## Background jobs

Start sidekiq from the root of your Rails application so the jobs will be processed:

```
bundle exec sidekiq
```

## Importing from purl:

```
$ ./bin/import_from_purl ../hybox-objects bc390xk2647 bc402fk6835 bc483gc9313
```
