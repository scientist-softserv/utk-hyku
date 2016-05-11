[![Build Status](https://travis-ci.org/projecthydra-labs/hybox.svg)](https://travis-ci.org/projecthydra-labs/hybox)
[![Coverage Status](https://coveralls.io/repos/projecthydra-labs/hybox/badge.svg?branch=master&service=github)](https://coveralls.io/github/projecthydra-labs/hybox?branch=master)
[![Stories in Ready](https://badge.waffle.io/projecthydra-labs/hybox.png?label=ready&title=Ready)](https://waffle.io/projecthydra-labs/hybox)
# hybox
Hydra-in-a-Box


## Development Dependencies

### Postgres

Hydra-in-a-Box supports multitenancy using the `apartment` gem. `apartment` works best with a postgres database.


## Background jobs

Start sidekiq from the root of your Rails application so the jobs will be processed:

```
bundle exec sidekiq
```

