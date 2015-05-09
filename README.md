# guru-scraper
Scrape all data!

## How to use
After cloning it to local
```
git clone git@github.com:raabbajam/guru-scraper
cd guru-scraper
npm i
```
create a `docs/config.coffe` file with your credentials
TODO create sample config file

type npm run to see what commands you can use
```
npm run
```
Here is some command
```
    "start": "DEBUG=raabbajam:* coffee index.coffee",
    "server": "DEBUG=raabbajam:* coffee server.coffee",
    "test": "mocha tests/**/**Spec.coffee --compilers coffee:coffee-script/register",
    "worker": "DEBUG=raabbajam:* coffee worker.coffee",
    "pm2:server": "DEBUG=raabbajam:* pm2 start server.coffee --interpreter ./node_modules/.bin/coffee",
    "pm2:worker": "DEBUG=raabbajam:* pm2 start worker.coffee --interpreter ./node_modules/.bin/coffee",
    "start-local": "CONFIG=test DEBUG=raabbajam:* coffee index.coffee",
    "worker-local": "CONFIG=test DEBUG=raabbajam:* coffee worker.coffee",
    "s:all": "pssh -l root -o /tmp/out -t 0 -h ./docs/servers.txt"
```
