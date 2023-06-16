defmodule ProblemService.MixProject do
  use Mix.Project

  def project do
    [
      app: :problem_service,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers:  Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ProblemService.Application, []},
      extra_applications: [:logger, :runtime_tools, :ueberauth_facebook, :que, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.5"},
      {:geo_postgis, "~> 3.4"},
      {:scrivener_ecto, "~> 2.0"},
      {:faker, "~> 0.17"},
      {:ueberauth_facebook, "~> 0.8"},
      {:guardian, "~> 2.0"},
      {:waffle_ecto, "~> 0.0"},
      {:que, "~> 0.10.1"},
      {:httpoison, "~> 2.0"},
      {:floki, "~> 0.33.0"},
      {:phoenix_api_toolkit, "~> 2.0.0"},
      # {:web_push_encryption, "~> 0.3.1"},
      {:cors_plug, "~> 3.0"},
      {:randomizer, "~> 1.1.0"},
      {:cachex, "~> 3.2"},
      {:openai, "~> 0.5.2"},
      {:yugo, "~> 0.3.0"},
      {:comeonin_ecto_password, "~> 3.0.0"},
      {:pbkdf2_elixir, "~> 1.0"},
      {:bodyguard, "~> 2.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
