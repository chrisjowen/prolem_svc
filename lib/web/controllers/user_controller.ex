defmodule Totem.UserController do
  use TotemWeb, :controller
  import Guardian.Plug

  def me(conn, params) do
    IO.inspect("PARAMS")
    IO.inspect(params)
    json(conn, current_resource(conn))
  end

  def id(conn, params) do
    json(conn, params)
  end

end
