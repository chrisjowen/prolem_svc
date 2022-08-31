defmodule Totem.UserController do
  use TotemWeb, :controller
  import Guardian.Plug

  def me(conn, _params) do
    json(conn, current_resource(conn))
  end
end
