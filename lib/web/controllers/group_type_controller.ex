defmodule Totem.GroupTypeController do
  use TotemWeb, :controller
  alias Totem.GroupTypeRepo

  def list(conn, _params) do
    results = GroupTypeRepo.all()
    json(conn, results)
  end

end
