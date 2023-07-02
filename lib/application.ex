defmodule ProblemService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ProblemService.Repo,
      ProblemService.Web.Telemetry,
      {Phoenix.PubSub, name: ProblemService.PubSub},
      ProblemService.Web.Endpoint,
      {Cachex, :lfg_cache},
      {Oban, Application.fetch_env!(:problem_service, Oban)}
    ]

    opts = [strategy: :one_for_one, name: ProblemService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProblemService.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
