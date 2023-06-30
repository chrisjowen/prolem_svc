defmodule ProblemService.VoteController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Vote


  def index(conn,%{"solution_id" => id} = params), do: super(assign(conn, :q, "solution_id=#{id}"), params)
  def index(conn,%{"problem_id" => id} = params), do: super(assign(conn, :q, "problem_id=#{id}"), params)
  def index(conn,%{"answer_id" => id} = params), do: super(assign(conn, :q, "answer_id=#{id}"), params)
  def index(conn,%{"discussion_id" => id} = params), do: super(assign(conn, :q, "discussion_id=#{id}"), params)
  def index(conn,%{"idea_id" => id} = params), do: super(assign(conn, :q, "idea_id=#{id}"), params)


end
