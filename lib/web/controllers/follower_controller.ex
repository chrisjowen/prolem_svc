defmodule ProblemService.FollowerController do
  use ProblemService.BaseController, schema:  ProblemService.Schema.Follower, only: [:index, :unfollow, :create]
  alias ProblemService.Schema.Follower

  plug ProblemService.ClearOrderBy, only: [:index]

  def index(conn,%{"solution_id" => solution_id} = params), do: super(assign(conn, :q, "solution_id=#{solution_id}"), params)
  def index(conn,%{"problem_id" => problem_id} = params), do: super(assign(conn, :q, "problem_id=#{problem_id}"), params)
  def index(conn,params), do: super(conn,params)


  def unfollow(conn, %{"problem_id" => problem_id}) do
    user_id = current_resource(conn).id

    Follower
    |> Repo.get_by(problem_id: problem_id, user_id: user_id)
    |> Repo.delete()

    json(conn, :ok)
  end



end
