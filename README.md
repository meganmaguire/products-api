# Products API - A FUDO Challenge by @meganmaguire

Welcome to this simple API for Product management. You can set up this project by running the server locally or using Docker. However you wish to continue, let's first:

- Clone the repository by running: `git clone https://github.com/meganmaguire/products-api`

## Local setup
### Intalling Ruby

- Download and install [Rbenv](https://github.com/rbenv/rbenv).
- Install the appropriate Ruby version by running `rbenv install [version]` where `version` is the one located in [.ruby-version](.ruby-version)

### Installing gems

- Install the bundler: `gem install bundler`
- Install the gems: `bundle install`

### Application setup

The app is now ready to run. You can do this by executing `bundle exec puma -p 3000`. The app is now hosted on `http://localhost:3000`

## Setup using Docker

### Installing Docker

- Install [Docker Desktop](https://docs.docker.com/desktop/)
- Run the app and check that the Docker engine is up and running.

### Application setup

- Create the docker image containing the app: `docker build -t products-api .`
- Create the docker container: `docker create --name products-api -p 3000:3000 products-api:latest` 
- Run the created container: `docker start products-api`



The app is now rup and running, hosted on `http://localhost:3000`
