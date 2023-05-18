defmodule ProblemService.Public.SectorIdeaController do
  use ProblemService.BaseController
  alias ProblemService.IdeaRepo

  def list(conn, %{"sector_id" => sector_id}) do
    conn |> json(IdeaRepo.all_for_sector(sector_id))
  end

end
