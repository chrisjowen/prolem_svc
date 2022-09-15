defmodule Totem.NotificationController do
  use Totem.BaseController
  alias Totem.NotificationRepo


  def list(conn, _params) do
    user = current_resource(conn)
    r = NotificationRepo.with_user(user.id)
        |> NotificationRepo.all()

    json(conn, r)
  end


end
