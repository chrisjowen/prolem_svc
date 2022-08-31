import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :totem, Totem.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "totem_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  port: 5433,
  types: Totem.PostgresTypes

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :totem, TotemWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "P2zLD/0XMpatF5D2BIt+WdD0dNxQ+7tdNZGjSmQkCWqZGsZItDtY/VAoR3vYRXbj",
  server: false

# In test we don't send emails.
config :totem, Totem.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
