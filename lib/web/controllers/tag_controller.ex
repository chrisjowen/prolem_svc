defmodule EventService.TagController do
  use EventServiceWeb, :controller
  alias EventService.TagRepo

  def list(conn, _params) do
    json(conn, TagRepo.all())
  end

end
