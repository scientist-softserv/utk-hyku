# University of Tennessee Knoxville

---

## Table of Contents

- [Prerequisites](#prerequisites)
  - [Install Docker](#install-docker)
  - [Install Dory](#install-dory)
- [Running the stack](#running-the-stack)
  - [Getting Started](#getting-started)
  - [Metadata Profiles](#metadata-profiles)
  - [Troubleshooting](#troubleshooting)

---

## Prerequisites
### Install Docker
- Download [Docker Desktop](https://www.docker.com/products/docker-desktop) and log in

### Install Dory
On OS X or Linux we recommend running [Dory](https://github.com/FreedomBen/dory). It acts as a proxy allowing you to access domains locally such as app.test or tenant.app.test, making multitenant development more straightforward and prevents the need to bind ports locally. Be sure to [adjust your ~/.dory.yml file to support the .test tld](https://github.com/FreedomBen/dory#config-file).

_You can still run in development via docker with out Dory, but to do so please uncomment the ports section in docker-compose.yml_
```bash
gem install dory
```

## Running the stack
### Getting Started
1. Clone the repository and cd into the folder

2. Install Stack Car
```bash
gem install stack_car
```

3. If this is the first time building the application or if any of the dependencies changed, please build with:
```bash
sc build
```

4. After building the application please install and start dory:
```bash
dory up
```

5. Bring the container up with:
```bash
sc up
```

6. Once the application is up and running, navigate to [utk-hyku.test](https://utk-hyku.test)in the browser and log in with the following credentials in [1Pass](https://start.1password.com/open/i?a=LTLZ652TT5H5FHMYMASSH7PIXM&v=huuakin4bu4xanlhktv42qheam&i=rwoxygppajcurfqdyuebfxmb34&h=scientist.1password.com)
  - When loading a tenant you may need to login through the browser: un: samvera pw: hyku

### Metadata Profiles
In order to create or import any models, a metadata profile must be uploaded.
  - Dashboard >> Metadata Profiles >> Import Profile


### Troubleshooting
- Is dory up? Check with a `docker ps` do you see the dory container up and running? If not run `dory up`

- Did you [adjust your ~/.dory.yml file to support the .test tld](https://github.com/FreedomBen/dory#config-file)?

- Did you checkout main and give it a `git pull`?
  - In that `git pull` were there any updates to the config files? Do you need to rebuild with `sc build`?
  - If that does not work, your last ditch effort is to do a no-cache build (but it takes forever so talk to the Project Manager at this point to see what you should do with your time, rebuild or get help).
    ```bash
    # drop all containers and volumes
    docker-compose down -v
    docker-compose build --no-cache
    sc up
    ```
