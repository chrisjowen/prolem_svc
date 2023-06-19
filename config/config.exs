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
  origin: ["http://localhost:8080","http://localhost:3000", "http://localhost:5173", "http://127.0.0.1:5173", "http://problem.chrisjowen.net"],
  max_age: 86400,
  methods: ["GET", "POST", "DELETE", "PUT", "OPTIONS", "HEAD"]

# Configures the endpoint
config :problem_service, ProblemService.Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ProblemService.Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ProblemService.PubSub,
  live_view: [signing_salt: "gSpMyCEo"]

config :comeonin, Ecto.Password, Pbkdf2
config :comeonin, :pbkdf2_rounds, 120_000
config :comeonin, :pbkdf2_salt_len, 512

config :problem_service, ProblemService.SecurePipeline,
  module: ProblemService.Guardian,
  error_handler: ProblemService.AuthErrorHandler

#  config :swoosh, :api_client, ProblemService.ApiClient

# config :problem_service, ProblemService.Mailer,
#   adapter: Swoosh.Adapters.Mailgun,
#   api_key: System.get_env("MAILGUN_API_KEY"),
#   domain: System.get_env("MAILGUN_DOMAIN"),
#   base_url: "https://api.mailgun.net/v3"





config :problem_service, ProblemService.Mailer,
    adapter: Bamboo.MailgunAdapter,
    api_key: System.get_env("MAILGUN_API_KEY"),
    domain: System.get_env("MAILGUN_DOMAIN"),
    # base_uri: "https://api.eu.mailgun.net/v3",
    # base_uri: "https://api.mailgun.net/v3",
    hackney_opts: [
      recv_timeout: :timer.minutes(1)
    ]


config :problem_service, Util.Screenshot,
  token: System.get_env("SCREENSHOT_API_KEY")


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
    api_key: System.get_env("OPEN_AI_KEY") ,
    organization_key: "org-2cJ3cEThmAglpQRKQr3X2W64",
    http_options: [recv_timeout: 120_000]
  # optional, useful if you want to do local integration tests using Bypass or similar
  # (https://github.com/PSPDFKit-labs/bypass), do not use it for production code,
  # but only in your test config!
  # api_url: "http://localhost/"



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
