import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :amazon_tracker, AmazonTracker.Repo,
  username: "postgres",
  password: "postgres",
  database: "amazon_tracker_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :amazon_tracker, AmazonTrackerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "MNI/CWLK5D1Cp7VOVgIn/Eqn+e5VoZCpE6gUrHzsi2N37wGcnTsZJ1hwhW1Rin/6",
  server: false

# In test we don't send emails.
config :amazon_tracker, AmazonTracker.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
