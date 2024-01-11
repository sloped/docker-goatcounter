# Goatcounter Docker Image  
[![Build Status](https://drone.connermccall.com/api/badges/conner/docker-goatcounter/status.svg)](https://drone.connermccall.com/conner/docker-goatcounter)

This is an unofficial Docker Image for running [Goatcounter](https://www.goatcounter.com/).

This was based on https://github.com/baethon/docker-goatcounter. 

### Note
Goatcounter's author does [not recommend running](https://github.com/arp242/goatcounter#deploy-scripts-and-such) Goatcounter this way.

I see multiple advantages to using Docker even if it is not strictly necessary. But please be sure to keep the author's thinking in mind if you report issues to the Goatcounter repository. 

## How to use this image

### Docker Run

```bash
docker run --name goatcounter \
  -v ${pwd}/config:/conf/
  -e GOATCOUNTER_DOMAIN=stats.domain.com \
  -e GOATCOUNTER_EMAIL=admin@domain.com \
  sloped/goatcounter
```

This command will start a single instance with a pre-configured `stats.domain.com` site. It will store the database under your current directory under `/config` in an SQLite database `goatcounter`.sqlite3`. 

### Docker Compose

```
version: '3.3'

services:
  goatcounter:
    image: sloped/goatcounter
    container_name: goatcounter
    volumes:
      - ${pwd}/config:/conf
    environment:
      - GOATCOUNTER_DOMAIN=stats.domain.com
      - GOATCOUNTER_EMAIL=admin@domain.com
```
#### With Postgres

Note: I do not run this so you will need to figure out the connection string. If you do please send me a PR. 
```
version: '3.3'

services:
  goatcounter:
    image: sloped/goatcounter
    container_name: goatcounter
    volumes:
      - ${pwd}/config:/conf
    environment:
      - GOATCOUNTER_DOMAIN=stats.domain.com
      - GOATCOUNTER_EMAIL=admin@domain.com
      - GOATCOUNTER_DB=connectionString'
    depends_on:
      - db

  db:
    image: postgres
    container_name: goatcounter_db
    environment:
      POSTGRES_DB: goatcounter_db
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - ${pwd}/db_data:/var/lib/postgresql/data

```

## Environment Variables

### GOATCOUNTER_DOMAIN

Used to create the initial site. Default: localhost

Highly recommend you change this. 

### GOATCOUNTER_EMAIL

Defines the e-mail address of the admin user. Default: goatcounter@localhost

Highly recommend you change this. 

### GOATCOUNTER_PASSWORD

Defines the password for the admin user. 

Please change this or change your password in /user/auth immediately after logging in

### GOATCOUNTER_SMTP

This optional environment variable defines the SMTP server (e.g., smtp://user:pass@server.com:587) that will be used by the server.

Default: stdout - print email contents to stdout

### GOATCOUNTER_DB

This optional environment variable defines the location of the database. By default, the server will use a SQLite database. I would recommend sticking with that. 

It's possible to use the Postgres DB however, the image was not tested against it.

For persistent data be sure to add /conf as a volume. 

Default: sqlite:///conf/goatcounter.sqlite3

## CLI

Assuming you stuck with the goatcounter name noted above. 

### Docker Run

`docker exec goatcounter {cmd}` 

### Compose

`docker-compose exec goatcounter goatcounter`