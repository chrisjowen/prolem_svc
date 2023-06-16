defmodule ProblemService.Workers.SchemaUpdatedWorker do
  use Que.Worker, concurrency: 50
  alias ProblemService.Web.Endpoint
  alias ProblemService.Repo
  alias ProblemService.Schema
  alias ProblemService.Services.NotificationService

  require Logger

  def perform([%Schema.Problem{} = problem, mode]) do
    followers = Schema.Follower.by_problem(problem.id)
    |> Repo.all()
    |> IO.inspect
    |> Repo.preload([:user])
    |> Enum.each(fn f ->
      NotificationService.notify(:problem_updated, f.user, problem)
    end)
  end

  def perform(args) do
    IO.inspect("NO I AM HEREEERE")

    IO.inspect(args)
  end
end
