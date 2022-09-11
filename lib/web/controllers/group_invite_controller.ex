defmodule Totem.GroupInviteController do
  use Totem.BaseController
  alias Totem.GroupInviteRepo


  def list(conn, %{"group_id" => group_id} = params) do
    result = GroupInviteRepo.in_group(group_id) |> GroupInviteRepo.all(params, [:to])
    json(conn, result)
  end


  def create(conn, params) do
    with {:ok, media} <- GroupInviteRepo.insert(params) do
      json(conn, media)
    end
  end

end
