### Installing the application in a developent environment at Notch8

1. First clone the repository and cd into the folder

2. Install Stack Car
```bash
gem install stack_car
```

3. If this is the first time building the application or if any of the dependancies changed, please build with:
```bash
sc build
```

4. After building the application please install and start dory with:
```bash
gem install dory
dory up
```
Note: Be sure to [adjust your ~/.dory.yml file to support the .test tld](https://github.com/FreedomBen/dory#config-file).

5. Bring the container up with:
```bash
sc up
```

6. Once the application is up and running, navigate to [utk-hyku.test](https://utk-hyku.test)in the browser and log in with the following credentials in [1Pass](https://start.1password.com/open/i?a=LTLZ652TT5H5FHMYMASSH7PIXM&v=huuakin4bu4xanlhktv42qheam&i=rwoxygppajcurfqdyuebfxmb34&h=scientist.1password.com) && Sometimes when loading a tenant in staging you may need this login information through the browser, un: samvera pw: hyku

### Troubleshotting Tips & Tricks:
- Is dory up? Check with a `docker ps` do you see the dory container up and running? If not run `dory up`

- Did you [adjust your ~/.dory.yml file to support the .test tld](https://github.com/FreedomBen/dory#config-file)?

- Did you checkout main and give it a `git pull`?

- In that `git pull` was there any updates to the config files? Should you need to rebuild?

- If you need to rebuild you can go `docker-compose down -v` and `rm -rf solr_db_initialized` and verify you removed it by `ls`, once removed completly, proceed to step 3.

- If that does not work your last ditch effort is to do a no-cache build (but it takes forever so talk to the Project Manager at this point to see what you should do with your time, rebuild or get help).

- If you have been instructed to proceed with a no-cache build here are the instructions. Start off at a fresh slate and dump all your volumes with `docker-compose down -v` and remove the solr_db_initilized file with `rm -rf solr_db_initialized` and verify you removed it by checking you don't see it with `ls`, once confirmed it's been removed run `docker-compose build --no-cache`. Once that has successfully built you can proceed to step 4.