defmodule Totem.PushSubController do
  use Totem.BaseController
  alias Totem.PushSubRepo

  def create(conn, params) do
    result = PushSubRepo.insert!(params)
    json(conn, result)
  end

end
