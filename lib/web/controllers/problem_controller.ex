defmodule ProblemService.ProblemController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Problem

  def submit(conn, %{"problem" => problem, "identifer" => identifer, "sector_id" => sector_id}) do
    params = %{
      problem: problem,
      user_id: 1,
      sector_id: sector_id,
      identifier: identifer
    }
    Que.add(
      ProblemService.Workers.ProblemCurationWorker,
      params
    )
    json(conn, :ok)
  end
end
