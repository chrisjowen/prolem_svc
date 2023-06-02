defmodule ProblemService.UserController do
  use ProblemService.BaseController
  import Guardian.Plug

  defcrud(ProblemService.Schema.User, [:show])

  def me(conn, _params) do
    json(conn, current_resource(conn))
  end

  def id(conn, params) do
    json(conn, params)
  end


end
