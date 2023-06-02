defmodule ProblemService.ProblemFollowerController do
  use ProblemService.BaseController
  alias ProblemService.Schema.ProblemFollower

  def follow(conn, %{"problem_id" => problem_id}) do
    params = %{
      problem_id: problem_id,
      user_id: current_resource(conn).id
    }

    with {:ok, problem_follower} <- ProblemFollower |> Repo.change(params) |> Repo.insert do
      json(conn, problem_follower)
    end
  end

  def unfollow(conn, %{"problem_id" => problem_id}) do
    user_id = current_resource(conn).id

    ProblemFollower
    |> Repo.get_by(problem_id: problem_id, user_id: user_id)
    |> Repo.delete()

    json(conn, :ok)
  end
end
