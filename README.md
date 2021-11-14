# AmazonTracker

start postgres

```
docker run --rm --name postgres-db -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
mix ecto.create
```
