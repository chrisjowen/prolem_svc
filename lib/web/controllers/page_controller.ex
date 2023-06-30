defmodule ProblemService.PageController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Page

  def index(conn, %{"solution_id" => solution_id} = params),
    do: super(assign(conn, :q, "solution_id=#{solution_id}"), params)

  def index(conn, %{"problem_id" => problem_id} = params),
    do: super(assign(conn, :q, "problem_id=#{problem_id}"), params)





end
