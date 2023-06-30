defmodule ProblemService.IdeaController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Idea
  alias ProblemService.Schema.Idea



  def search(conn, %{"sectors" => sector_ids} = params) do
    super(conn, params)
      |> Idea.with_sectors(String.split(sector_ids, ","))
  end
  def search(conn, params), do: super(conn, params)


end
