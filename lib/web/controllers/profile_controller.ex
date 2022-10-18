defmodule Totem.ProfileController do
  use TotemWeb, :controller
  import Guardian.Plug
  alias Totem.GroupRepo


  def me(conn, _params) do
    json(conn, current_resource(conn))
  end

  def groups(conn, %{"id" => id}) do
    groups = GroupRepo.with_active()
    |> GroupRepo.with_member(id)
    |> GroupRepo.all()

    conn |> json(groups)
  end



end
