defmodule ProblemService.PageController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Page

  def index(conn, %{"solution_id" => solution_id} = params),
    do: filter(assign(conn, :q, "solution_id=#{solution_id}"), params)

  def index(conn, %{"problem_id" => problem_id} = params),
    do: filter(assign(conn, :q, "problem_id=#{problem_id}"), params)


    @excluded_fields [
      {ProblemService.Schema.Page, [:body]},
    ]

    def filter(conn, params) do
      searchable_fileds = @excluded_fields ++ Modules.modules()
      result =
        search(conn, params)
        |> Util.MapUtil.from_struct(searchable_fileds)  # TODO: This can be automatically done

      json(conn, result)
    end


end
