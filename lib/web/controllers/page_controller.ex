defmodule ProblemService.PageController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Page
  import Ecto.Query


  def index(conn, %{"solution_id" => solution_id} = params),
    do: super(assign(conn, :q, "solution_id=#{solution_id}"), params)

  def index(conn, %{"problem_id" => problem_id} = params),
    do: super(assign(conn, :q, "problem_id=#{problem_id}"), params)


  # def index(conn, params),
  #   do: super(assign(conn, :q, "problem_id[nil]=true"), params)

  def index(conn, params) do
    query = search(conn, params)

    query = from q in query,
      where: is_nil(q.problem_id)

    results = query
    |> Repo.paginate(params)

    json(conn, results)
  end

end
