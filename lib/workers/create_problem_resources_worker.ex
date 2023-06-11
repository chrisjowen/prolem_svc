defmodule ProblemService.Workers.CreateProblemResourcesWorker do
  use Que.Worker, concurrency: 50
  alias ProblemService.Web.Endpoint
  alias ProblemService.Repo
  alias ProblemService.Schema.Problem
  alias ProblemService.Schema.Link
  require Logger

  def perform(%{"problem_id" => problem_id}) do
    # TODO: Im allowing myself to do EVERYTHING here, change to workflow later
    Repo.get(Problem, problem_id) |> Repo.preload([:sector]) |> create_problem_resources()
  end

  defp create_problem_resources(problem) do
    Endpoint.broadcast!("problem:#{problem.id}", "problem:links:creating", %{})
    with {:ok, response} <- Ai.ProblemResourceGenerator.execute(problem.overview, problem.sector.name) do
      tasks = response["resources"]
      |> Enum.map(fn resource ->
          Task.async(fn -> test_and_save_resource(problem, resource) end)
      end)

      Task.await_many(tasks, 50_000)
      Endpoint.broadcast!("problem:#{problem.id}", "problem:links:created", %{})
    end
  end

  defp test_and_save_resource(problem, resource) do
    Logger.info("Checking resource: #{resource["url"]}")

    with {:ok, %HTTPoison.Response{status_code: status_code}} when status_code in 200..299 <- HTTPoison.get(resource["url"]) do
      Logger.info("Creating problem resource: #{resource["url"]}")
      save_resource(problem, resource)
    else
      _ ->  Logger.info("Invalid resource: #{resource["url"]}")
    end
  end

  defp save_resource(problem, resource) do
    Link.changeset(%Link{}, %{
      problem_id: problem.id,
      text: resource["text"],
      url: resource["url"],
      type: resource["type"]
    })
    |> Repo.insert()
    Endpoint.broadcast!("problem:#{problem.id}", "problem:links:added", %{})
  end
end
