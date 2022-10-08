defmodule Totem.GroupInviteController do
  use Totem.BaseController
  alias Totem.GroupInviteRepo
  alias Totem.Workers

  def list(conn, %{"group_id" => group_id} = params) do
    result = GroupInviteRepo.in_group(group_id) |> GroupInviteRepo.all(params, [:to])
    json(conn, result)
  end

  def mine(conn, params) do
    result =
      GroupInviteRepo.with_to(current_resource(conn).id)
      |> GroupInviteRepo.all(params, [:user, :to, :group])

    json(conn, result)
  end

  def create(conn, params) do
    with {:ok, invite} <- GroupInviteRepo.insert(params),
         {:ok, _} <- Que.add(Workers.GroupInviteEventProcessor,
             invite: invite
           ) do
      json(conn, invite)
    end
  end
end
