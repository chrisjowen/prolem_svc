defmodule ProblemService.Workers.CreateStakeholdersWorker do
  use Que.Worker, concurrency: 10

  alias ProblemService.Schema.Stakeholder
  alias ProblemService.Schema.Problem
  alias ProblemService.Repo

  require Logger

  def perform(%{"problem_id" => problem_id}) do
    Logger.info("Creating stakeholders for problem #{problem_id}")

    with problem <- Repo.get(Problem, problem_id),
         {:ok, results} <- Ai.StakeholderGenerator.execute(problem.blurb, problem.overview) do
      persist_stakeholders(results, problem, 1)
    else
      {:error, reason} -> Logger.error("Error creating stakeholders: #{inspect(reason)}")
      unknown -> Logger.error("Error creating stakeholders: #{inspect(unknown)}")
    end
  end

  def persist_stakeholders(results, problem, user_id) do
    Logger.info("Found stakeholders, persisting")

    results["stakeholders"]
    |> Enum.map(&persist_stakeholder(&1, problem, user_id))
  end

  def persist_stakeholder(stakeholder, problem, user_id) do
    additional = %{
      "problem_id" => problem.id,
      "user_id" => user_id
    }

    params = Map.merge(stakeholder, additional)

    stakeholder =
      %Stakeholder{}
      |> Stakeholder.changeset(params)
      |> Repo.insert!()

    Que.add(ProblemService.Workers.CreateStakeholderImageWorker, %{"stakeholder_id" => stakeholder.id})
  end
end
