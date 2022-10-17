defmodule Totem.NotificationController do
  use Totem.BaseController
  alias Totem.NotificationRepo


  def list(conn, _params) do
    user = current_resource(conn)
    r = NotificationRepo.with_user(user.id)
        |>  NotificationRepo.with_unread()
        |> NotificationRepo.all()

    json(conn, r)
  end


  def clear(conn, _params) do
    user = current_resource(conn)
     NotificationRepo.with_user(user.id)
        |> NotificationRepo.all()
        |> Enum.map(&NotificationRepo.read/1)

    json(conn, :ok)
  end


end
