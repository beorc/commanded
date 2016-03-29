use Mix.Config

config :eventstore, EventStore.Storage,
  username: "postgres",
  password: "postgres",
  database: "eventstore_dev",
  hostname: "localhost",
  pool_size: 10
