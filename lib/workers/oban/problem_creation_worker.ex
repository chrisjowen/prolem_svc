defmodule ProblemService.Workers.ProblemCreationWorker do
  require Logger
  alias ProblemService.Web.Endpoint
  alias ProblemService.Schema.Problem
  alias ProblemService.Repo
  alias ProblemService.Workers.ProblemStakeholdersWorker
  alias ProblemService.Workers.ProblemImageWorker

  use Oban.Worker,
    queue: :default,
    max_attempts: 5

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"problem_id" => id, "user_id" => user_id}}) do
    IO.inspect("Broadcasting problem:overview:creating for user#{id}")

    problem = Repo.get(Problem, id)

    Endpoint.broadcast!("user:#{user_id}", "problem:overview:creating", %{id: id})

    with {:ok, overview} <- Ai.ProblemStatementGenerator.execute(problem.blurb),
         {:ok, _} <- Repo.update(Problem.changeset(problem, %{overview: overview})) do
      trigger_jobs(id, user_id)
      Endpoint.broadcast!("user:#{user_id}", "problem:overview:complete", %{id: id})
    else
      error ->
        Endpoint.broadcast!("user:#{user_id}", "problem:overview:error", %{id: id})
        Logger.error("Error: #{inspect(error)}")
    end

    Logger.debug("Generating problem statement for #{id}")
  end

  def perform(%Oban.Job{args: args}) do
    Logger.error("Missed #{inspect(args)}")
  end

  def trigger_jobs(id, user_id) do
    ProblemStakeholdersWorker.new(%{"problem_id" => id, "user_id" => user_id})
    |> Oban.insert!()

    ProblemImageWorker.new(%{"problem_id" => id, "user_id" => user_id})
    |> Oban.insert!()
  end
end
