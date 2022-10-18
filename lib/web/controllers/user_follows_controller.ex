defmodule Totem.UserFollowController do
  use Totem.BaseController
  alias Totem.UserFollowRepo
  alias Totem.Workers.UserFollowsProcessor

  def list(conn, params) do
    me = current_resource(conn)

    follows =
      UserFollowRepo.with_user(me)
      |> UserFollowRepo.all(params, [:to])

    json(conn, follows)
  end

  def create(conn, params) do
    with {:ok, follow}  <- UserFollowRepo.insert(params),
         {:ok, _} <- Que.add(UserFollowsProcessor, follow: follow) do
      json(conn, follow)
    end
  end

end
