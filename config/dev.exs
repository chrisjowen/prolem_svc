import Config

# Configure your database
config :event_service, EventService.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "event_service_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  types: EventService.PostgresTypes

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "773947543964189",
  client_secret: "afaac670206d02cbc2ddfaaec0f8fb8b"


config :event_service, EventService.AuthController,
  completion_url: "http://localhost:8080/callback/"

config :ueberauth, Ueberauth,
  providers: [
    facebook:
      {Ueberauth.Strategy.Facebook,
       [
         default_scope: "email,public_profile,user_friends",
         callback_url: "http://localhost:4000/auth/facebook/callback"
       ]}
  ]

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :event_service, EventServiceWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "VU3A3GKLNuJdZloBqduRcisaKAKlgN5Pq2XGt9OgU2kKwQ75aW1GkPYaFKs86O9j",
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
