defmodule ProblemService.WorkflowController do
  use ProblemService.BaseController
  alias Guardian.UUID
  alias ProblemService.Workers

  def problem_generator(conn, params) do
    with {:ok, job} =
           Workers.ProblemCreationWorker.new(
             params
             |> Map.put("user_id", current_resource(conn).id)
           )
           |> Oban.insert() do
      json(conn, %{job_id: job.id})
    end
  end

  def problem_template(conn, params) do
    trace_id = UUID.generate()

    Que.add(
      ProblemService.Workers.CreateProblemTemplateWorker,
      params
      |> Map.put("user_id", current_resource(conn).id)
      |> Map.put("trace_id", trace_id)
    )

    json(conn, %{trace_id: trace_id})
  end

  def problem_suggestions(conn, params) do
    filters = Map.get(params, "filters", "") |> String.split(",")

    Que.add(
      ProblemService.Workers.CreateProblemSuggestionsWorker,
      filters
    )

    json(conn, :ok)
  end

  def problem_resources(conn, %{"problem_id" => problem_id} = params) do
    Que.add(
      ProblemService.Workers.CreateProblemResourcesWorker,
      params
    )

    json(conn, :ok)
  end

  def problem_obstacles(conn, %{"problem_id" => problem_id} = params) do
    Que.add(
      ProblemService.Workers.CreateProblemObstaclesWorker,
      params
    )

    json(conn, :ok)
  end

  def problem_stakeholders(conn, %{"problem_id" => problem_id} = params) do
    Que.add(
      ProblemService.Workers.CreateStakeholdersWorker,
      params
    )

    json(conn, :ok)
  end

  def ideas(conn, %{"sector_id" => sector_id} = params) do
    Que.add(ProblemService.Workers.CreateIdeasWorker, params)
    json(conn, :ok)
  end
end
