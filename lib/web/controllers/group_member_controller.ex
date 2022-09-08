defmodule Totem.GroupMemberController do
  use Totem.BaseController
  alias Totem.GroupMemberRepo
  alias Totem.GroupChatRepo

  def list(conn, %{"group_id" => group_id}) do
    result = GroupMemberRepo.in_group(group_id)
        |> GroupMemberRepo.all(%{}, [:user])

    json(conn, result)
  end

  def create(conn, params) do
    # TODO: Permissions check
    me = current_resource(conn)
    with {:ok, membership} <- GroupMemberRepo.insert(params),
         {:ok, message} <-
           GroupChatRepo.insert(%{
             group_id: params["group_id"],
             user_id: params["user_id"],
             msg: "#{me.name} #{me.last_name} joined the group"
           }),
         message <- GroupChatRepo.get(message.id, [:user, :media]) do
      TotemWeb.Endpoint.broadcast!("group:#{params["group_id"]}", "msg", message)
      json(conn, membership)
    end
  end
end
