defmodule ProblemService.ProblemFollowerController do
  use ProblemService.BaseController
  alias ProblemService.ProblemFollowerRepo

  def follow(conn, %{"problem_id" => problem_id}) do
    params = %{
      problem_id: problem_id,
      user_id: current_resource(conn).id
    }

    with {:ok, problem_follower} <- ProblemFollowerRepo.insert(params) do
      json(conn, problem_follower)
    end
  end

  def unfollow(conn, %{"problem_id" => problem_id}) do
    ProblemFollowerRepo.unfollow( problem_id, current_resource(conn).id)
    json(conn, :ok)
  end


end
