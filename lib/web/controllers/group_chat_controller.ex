defmodule Totem.GroupChatController do
  use TotemWeb, :controller
  alias Totem.GroupChatRepo
  # import Guardian.Plug

  def list(conn, %{"group_id" => id}) do
    json(conn, GroupChatRepo.latest(id) |> IO.inspect)
  end

end
