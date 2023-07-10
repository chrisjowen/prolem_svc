defmodule ProblemService.Workers.ProblemStakeholdersWorker do
  require Logger
  alias ProblemService.Web.Endpoint
  alias ProblemService.Schema.Problem
  alias ProblemService.Schema.Stakeholder
  alias ProblemService.Repo

  use Oban.Worker,
    queue: :default,
    max_attempts: 5

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"problem_id" => id, "user_id" => user_id}}) do
    Endpoint.broadcast!("user:#{user_id}", "problem:stakeholders:creating", %{id: id})
    Logger.debug("Broadcasting problem:stakeholders:creating for user:#{id}")

    problem = Repo.get(Problem, id)

    with {:ok, results} <- Ai.StakeholderGenerator.execute(problem.blurb, problem.overview) do
      persist_stakeholders(results, problem, user_id)
    else
      {:error, reason} ->
        Endpoint.broadcast!("user:#{user_id}", "problem:stakeholders:error", %{error: reason})
        Logger.error("Error creating stakeholders: #{inspect(reason)}")
        {:error, reason}

      unknown ->
        Endpoint.broadcast!("user:#{user_id}", "problem:stakeholders:error", %{error: "unknown"})
        Logger.error("Error creating stakeholders: #{inspect(unknown)}")
        unknown
    end
  end

  def persist_stakeholders(results, problem, user_id) do
    Logger.info("Found stakeholders, persisting")
    results["stakeholders"]
    |> Enum.map(&persist_stakeholder(&1, problem, user_id))

    Endpoint.broadcast!("user:#{user_id}", "problem:stakeholders:complete", %{id: problem.id})
    Logger.debug("Broadcasting problem:stakeholders:complete for user:#{user_id}")
  end

  def persist_stakeholder(stakeholder, problem, user_id) do
    additional = %{
      "problem_id" => problem.id,
      "user_id" => user_id
    }
    params = Map.merge(stakeholder, additional)
    %Stakeholder{}
    |> Stakeholder.changeset(params)
    |> Repo.insert!()
  end
end
