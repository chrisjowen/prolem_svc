defmodule Totem.UserFollowController do
  use Totem.BaseController
  alias Totem.UserFollowRepo

  def list(conn, params) do
    me = current_resource(conn)

    follows =
      UserFollowRepo.with_user(me)
      |> UserFollowRepo.all(params, [:to])

    json(conn, follows)
  end

  def create(conn, params) do
    json(conn, UserFollowRepo.insert!(params))
  end
end
