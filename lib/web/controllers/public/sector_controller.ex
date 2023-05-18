defmodule ProblemService.Public.SectorController do
  use ProblemService.BaseController
  alias ProblemService.SectorRepo

  def list(conn, _params) do
    conn |> json(SectorRepo.all())
  end

  def show(conn, %{"id" => id}) do
    json(conn, SectorRepo.get(id))
  end

end
