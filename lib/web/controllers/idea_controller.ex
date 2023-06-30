defmodule ProblemService.IdeaController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Idea
  alias ProblemService.Schema.Idea


  def search(conn, %{"sectors" => sector_ids} = params) do
    super(conn, params)
      |> Idea.with_sectors(String.split(sector_ids, ","))
  end
  def search(conn, params), do: super(conn, params)


  def tags(conn, _params) do
    tags = Idea |> Repo.all() |> Enum.map(&(&1.tags)) |> List.flatten() |> Enum.uniq()
    json(conn, tags)
  end

  def skills(conn, _params) do
    skills = Idea |> Repo.all() |> Enum.map(&(&1.skills)) |> List.flatten() |> Enum.uniq()
    json(conn, skills)
  end


end
