defmodule ProblemService.SectorController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Sector, only: [:show, :index]

  @excluded_fields [
    {ProblemService.Schema.Sector, [:description]},
    {ProblemService.Schema.Problem, [:overview]},
  ]


  def index(conn, params) do
    searchable_fileds = @excluded_fields ++ Modules.modules()
    result =
      search(conn, params)
      |> Util.MapUtil.from_struct(searchable_fileds)  # TODO: This can be automatically done
    json(conn, result)
  end


end
