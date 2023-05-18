defmodule ProblemService.Public.IdeaController do
  use ProblemService.BaseController
  alias ProblemService.IdeaRepo

  def list(conn, _params) do
    conn |> json(IdeaRepo.all())
  end

  def show(conn, %{"id" => id}) do
    json(conn, IdeaRepo.get(id, [:sector]))
  end
end
