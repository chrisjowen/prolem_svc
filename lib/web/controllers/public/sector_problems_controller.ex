defmodule ProblemService.Public.SectorProblemsController do
  use ProblemService.BaseController
  alias ProblemService.ProblemRepo

  def list(conn, %{"sector_id" => sector_id}) do
    conn |> json(ProblemRepo.all_for_sector(sector_id))
  end

end
