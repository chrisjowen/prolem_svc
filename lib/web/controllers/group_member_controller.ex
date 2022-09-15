defmodule Totem.GroupMemberController do
  use Totem.BaseController
  alias Totem.GroupMemberRepo
  alias Totem.Workers

  def list(conn, %{"group_id" => group_id}) do
    result =
      GroupMemberRepo.in_group(group_id)
      |> GroupMemberRepo.all(%{}, [:user])

    json(conn, result)
  end

  def create(conn, params) do
    # TODO: Permissions check
    me = current_resource(conn)
    with {:ok, membership} <- GroupMemberRepo.insert(params),
         {:ok, _} <-
           Que.add(Workers.GroupMemberEventProcessor,
             group_id: params["group_id"],
             user_id: params["user_id"],
             sender_id: me.id
           ) do
      json(conn, membership)
    end
  end
end
