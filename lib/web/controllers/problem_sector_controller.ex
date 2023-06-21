defmodule ProblemService.ProblemSectorController do
  use ProblemService.BaseController, schema: ProblemService.Schema.ProblemSector
  plug ProblemService.ClearOrderBy, only: [:index]


  def index(conn,%{"problem_id" => problem_id} = params), do: super(assign(conn, :q, "problem_id=#{problem_id}"), params)
  def index(conn,%{"sector_id" => sector_id} = params), do: super(assign(conn, :q, "sector_id=#{sector_id}"), params)
end
