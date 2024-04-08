# README

## Setup Rails Project
1. `docker run --name postgres-nimble -p 5431:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -d -v pgdata:/var/lib/postgresql/data postgres:15.4
2. bundle install
3. rails db:create
4. rake RAILS_ENV=test db:create

## .env.development file
RAILS_ENV=development
RAILS_MAX_THREADS=12
DATABASE_HOST=localhost
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_PORT=5431
DATABASE_NAME=nimble_db

12 threads is necessary as datascraping is being done with a maximum of 10 threads

## Bypass google mass-seach not implemented. Things I've tried:
1. Using proxy servers
2. Rotate user agents
3. Adding sleep to mimic human behaviour

## Things to improve in this project
1. Add tests for models.
2. Add tests for serializers.
3. Add tests for services.
