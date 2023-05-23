defmodule ProblemService.UserController do
  use ProblemService.BaseController
  import Guardian.Plug
  alias ProblemService.UserRepo


  def me(conn, _params) do
    json(conn, current_resource(conn))
  end

  def show(conn, %{"id" => id} = params) do
    conn |> json(UserRepo.get(id, params))
  end

  def id(conn, params) do
    json(conn, params)
  end

  def search(conn, %{"q" => q}) do
    conn |> json(UserRepo.search(q))
  end

end
