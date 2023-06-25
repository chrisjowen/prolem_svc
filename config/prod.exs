import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :problem_service, ProblemService.Web.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
client_id: "773947543964189",
client_secret: "afaac670206d02cbc2ddfaaec0f8fb8b"

config :problem_service, ProblemService.AuthController,
  completion_url: "https://group.chrisjowen.net/callback/"

config :ueberauth, Ueberauth,
providers: [
  google:   {Ueberauth.Strategy.Google, [default_scope: "email profile", callback_url: "https://www.crowdsolve.ai/oauth/google/callback"]},
  facebook: {Ueberauth.Strategy.Facebook, [ default_scope: "email,public_profile",callback_url: "https://www.crowdsolve.ai/oauth/facebook/callback"]}
]

# Do not print debug messages in production
config :logger, level: :debug

# mix phx.gen.schema GroupMember group_members user_id:references:users is_host:boolean status:string
