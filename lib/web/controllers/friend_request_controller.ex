defmodule Totem.FriendRequestController do
  use Totem.BaseController
  alias Totem.FriendRequestRepo

  def list(conn, params) do
    me = current_resource(conn)

    follows =
      FriendRequestRepo.with_user(me)
      |> FriendRequestRepo.all(params, [:to])

    json(conn, follows)
  end

  def create(conn, params) do
    json(conn, FriendRequestRepo.insert!(params))
  end
end
