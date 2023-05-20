defmodule ProblemService.ProblemFollowerRepo do
  use ProblemService.SchemaRepo, schema: ProblemService.Schema.ProblemFollower

  def unfollow(problem_id, user_id) do
    query =
      from pf in @this,
      where: pf.problem_id == ^problem_id and pf.user_id == ^user_id

    query |> delete_all()
  end
end
