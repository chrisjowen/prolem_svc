# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :problem_service,
  ecto_repos: [ProblemService.Repo]

config :cors_plug,
  origin: ["http://localhost:8080"],
  max_age: 86400,
  methods: ["GET", "POST"]

# config :web_push_encryption, :vapid_details,
#   subject: "mailto:hello@reddotz.com",
#   public_key: "BFQyyzI-VwFmI-3pdXfnlIR9AUBaDCO0suRKG32e6Y8fSv6nvzBOfMP8zxrstvN7WyqA9HVMaF7wsM3KQKsZLJY",
#   private_key: "5Tk7JFzIdJNwVB68yhWYeFicliNCkRCT3xVJyUFHHi8"

# Configures the endpoint
config :problem_service, ProblemService.Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ProblemService.Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ProblemService.PubSub,
  live_view: [signing_salt: "gSpMyCEo"]

config :problem_service, ProblemService.SecurePipeline,
  module: ProblemService.Guardian,
  error_handler: ProblemService.AuthErrorHandler


config :waffle,
  storage: Waffle.Storage.Local,
  asset_host: {:system, "ASSET_HOST"}

config :problem_service, ProblemService.Guardian,
  issuer: "problem_service",
  secret_key: "SIs0ZqwWwih49ZMx5CeXI2eY0q5Mv6n9gYz1xKvatjBdlpL4Pfo7HAgn/Gug2qtr6"


  # config :logger, level: :error

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :problem_service, ProblemService.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :geo_postgis,
  json_library: Jason


  config :openai,
    api_key: "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",
    organization_key: "org-2cJ3cEThmAglpQRKQr3X2W64",
    http_options: [recv_timeout: 120_000]
  # optional, useful if you want to do local integration tests using Bypass or similar
  # (https://github.com/PSPDFKit-labs/bypass), do not use it for production code,
  # but only in your test config!
  # api_url: "http://localhost/"



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
