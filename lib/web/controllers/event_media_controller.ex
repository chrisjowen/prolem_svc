defmodule EventService.EventMediaController do
  use EventServiceWeb, :controller
  alias EventService.EventMediaRepo
  import Guardian.Plug

  def create(conn, params) do
    user = current_resource(conn)
    params = Map.put(params, "user_id", user.id)

    with {:ok, media} <- EventMediaRepo.insert(params) do
      json(conn, media)
    end
  end

  def list(conn, _) do
    EventMediaRepo.all() |> IO.inspect()
    json(conn, EventMediaRepo.all())
  end

  def raw(conn, %{"id" => id} = params) do
    type =  Map.get(params, "type", "original")
    ratio = case type do
      "thumb" -> :thumb
      "original" -> :original
    end

    media = EventMediaRepo.get(id) |> IO.inspect
    data =  File.cwd! <> (EventService.Media.url({media.media, media}, ratio) |> String.replace(~r/\?[a-z0-9=]+/, ""))
    |> File.read!

    conn
    |> put_resp_content_type("image/png")
    |> send_resp(200, data)

  end
end
