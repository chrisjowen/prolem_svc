defmodule Totem.UserController do
  use TotemWeb, :controller
  import Guardian.Plug
  alias Totem.UserRepo


  def me(conn, params) do
    json(conn, current_resource(conn))
  end

  def id(conn, params) do
    json(conn, params)
  end

  def search(conn, %{"q" => q}) do
    conn |> json(UserRepo.search(q))
  end

end
