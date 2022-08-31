defmodule Totem.TagController do
  use TotemWeb, :controller
  alias Totem.TagRepo

  def list(conn, _params) do
    json(conn, TagRepo.all())
  end

end
