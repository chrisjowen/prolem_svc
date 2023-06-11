defmodule ProblemService.CommentController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Comment

  plug ProblemService.SetQuery, only: [:index]


  def index(conn,%{"solution_id" => solution_id} = params), do: super(assign(conn, :q, "solution_id=#{solution_id}"), params)
  def index(conn,%{"problem_id" => problem_id} = params), do: super(assign(conn, :q, "problem_id=#{problem_id}"), params)

end
