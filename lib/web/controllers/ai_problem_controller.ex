defmodule ProblemService.AIProblemController do
  use ProblemService.BaseController


  def execute(conn, %{"type" => type}  = params) do
    case type do
      "precheck" -> precheck(conn, params)
      "statement" -> problem_statement(conn, params)
      "meta" -> meta(conn, params)
      "links" -> links(conn, params)
      "obstacles" -> obstacles(conn, params)
      "discussions" -> discussions(conn, params)
      "suggestions" -> suggestions(conn, params)
      "resources" -> resources(conn, params)
      _ -> json(conn, %{error: "Invalid Problem Adviser cannot advise on type"})
    end
  end


  def precheck(conn, %{"statement" => statement}) do
    sectors = Repo.all(ProblemService.Schema.Sector)
    |> Enum.map(fn sector -> sector.name  end)

    with {:ok, response} <- Ai.ProblemPrecheck.execute(statement, sectors) do
      json(conn, response)
    end
  end

  def problem_statement(conn, %{"statement" => statement, "sector" => sector}) do
    with {:ok, response} <- Ai.ProblemStatement.execute(statement, sector) do
      json(conn, response)
    end
  end

  def meta(conn, %{"statement" => statement, "sector" => sector}) do
    with {:ok, response} <- Ai.ProblemStatementMetaGenerator.execute(statement, sector) do
      json(conn, response)
    end
  end


  def links(conn, %{"statement" => statement, "sector" => sector}) do
    with {:ok, response} <- Ai.ProblemLinksGenerator.execute(statement, sector) do
      json(conn, response)
    end
  end

  def obstacles(conn, %{"problem_id" => problem_id}) do
    problem = Repo.get!(ProblemService.Schema.Problem, problem_id) |> Repo.preload([:sector])
    statement = """
      <h1>#{problem.title}</h1>
      #{problem.overview}
    """
    with {:ok, response} <- Ai.ProblemObstaclesGenerator.execute(statement, problem.sector.name) do
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


  def resources(conn, %{"statement" => statement, "sector" => sector}) do
    with {:ok, response} <- Ai.ProblemResourceGenerator.execute(statement, sector) do
      json(conn, response)
    end
  end

end
