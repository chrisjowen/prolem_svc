defmodule Totem.EventTypeController do
  use TotemWeb, :controller
  alias Totem.EventTypeRepo

  def list(conn, _params) do
    results = EventTypeRepo.all()
    json(conn, results)
  end

end
