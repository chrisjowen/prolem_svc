defmodule ProblemService.Workers.CreateProblemObstaclesWorker do
  use Que.Worker, concurrency: 50
  alias ProblemService.Web.Endpoint
  alias ProblemService.Repo
  alias ProblemService.Schema.Problem
  alias ProblemService.Schema.Obstacle
  require Logger

  def perform(%{"problem_id" => problem_id}) do
    # TODO: Im allowing myself to do EVERYTHING here, change to workflow later
    Repo.get(Problem, problem_id) |> Repo.preload([:sector]) |> create_problem_resources()
  end

  defp create_problem_resources(problem) do
    Endpoint.broadcast!("user:#{problem.user_id}", "problem:obstacles:creating", %{})

    with {:ok, response} <- Ai.ProblemObstaclesGenerator.execute(problem.overview, problem.sector.name) do
        response["obstacles"]
        |> Enum.each(fn obstacle ->
          Obstacle.changeset(%Obstacle{}, %{
            problem_id: problem.id,
            description: obstacle["obstacle"],
            questions: obstacle["questions"],
            hint: obstacle["solutionHint"],
            tags: obstacle["types"]
          })
          |> Repo.insert()
        end)

      Endpoint.broadcast!("user:#{problem.user_id}", "problem:obstacles:created", %{})
    end
  end

end
