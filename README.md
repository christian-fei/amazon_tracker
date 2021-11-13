# AmazonTracker

start postgres

```
docker run --rm --name postgres-db -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
mix ecto.create
```

## notes

generated a new schema for amazon products with 

```
mix phx.gen.context Amazon Product products title:string url:string price:float
mix ecto.migrate
```