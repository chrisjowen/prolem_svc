defmodule ProblemService.ProblemController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Problem

  def submit(conn, %{"problem" => problem, "identifer" => identifer, "sector_id" => sector_id}) do
    params = %{
      problem: problem,
      user_id: 1,
      sector_id: sector_id,
      identifier: identifer
    }

    Que.add(
      ProblemService.Workers.ProblemCurationWorker,
      params
    )

    json(conn, :ok)
  end

  def precheck(conn, %{"statement" => statement, "sector" => sector}) do
    sectors = Repo.all(ProblemService.Schema.Sector)
    |> Enum.map(fn sector -> sector.name  end)

    with {:ok, response} <- Ai.ProblemPrecheck.execute(statement, sector, sectors) do
      json(conn, response)
    end
  end

  def problem_statement(conn, %{"statement" => statement, "sector" => sector}) do
    with {:ok, response} <- Ai.ProblemStatement.execute(statement, sector) do
      json(conn, response)
    end
  end

  def links(conn, %{"statement" => statement, "sector" => sector}) do
    with {:ok, response} <- Ai.ProblemLinksGenerator.execute(statement, sector) do
      json(conn, response)
    end
  end

  def obstacles(conn, %{"statement" => statement, "sector" => sector}) do
    with {:ok, response} <- Ai.ProblemObstaclesGenerator.execute(statement, sector) do
      json(conn, response)
    end
  end

  def discussions(conn, %{"statement" => statement, "sector" => sector}) do
    with {:ok, response} <- Ai.ProblemDiscussionGenerator.execute(statement, sector) do
      json(conn, response)
    end
  end

  def suggestions(conn, %{"sector" => sector}) do
    with {:ok, response} <- Ai.ProblemSuggestionGenerator.execute(sector) do
      json(conn, response)
    end
  end
end
