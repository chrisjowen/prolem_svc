defmodule ProblemService.StakeholderController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Stakeholder

  def index(conn,%{"problem_id" => problem_id} = params), do: super(assign(conn, :q, "problem_id=#{problem_id}"), params)
end
