defmodule EventService.UserController do
  use EventServiceWeb, :controller
  import Guardian.Plug

  def me(conn, _params) do
    json(conn, current_resource(conn))
  end
end
