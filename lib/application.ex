defmodule Totem.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Totem.Repo,
      # Start the Telemetry supervisor
      TotemWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Totem.PubSub},
      # Start the Endpoint (http/https)
      TotemWeb.Endpoint
      # Start a worker by calling: Totem.Worker.start_link(arg)
      # {Totem.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Totem.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TotemWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
