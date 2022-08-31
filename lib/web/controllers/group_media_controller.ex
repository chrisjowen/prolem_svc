defmodule Totem.GroupMediaController do
  use TotemWeb, :controller
  alias Totem.GroupMediaRepo
  import Guardian.Plug

  def create(conn, params) do
    user = current_resource(conn)
    params = Map.put(params, "user_id", user.id)

    with {:ok, media} <- GroupMediaRepo.insert(params) do
      json(conn, media)
    end
  end

  def list(conn, %{"group_id" => group_id}) do
    result = GroupMediaRepo.in_group(group_id)
        |> GroupMediaRepo.all

    json(conn, result)
  end

  def raw(conn, %{"id" => id} = params) do
    type =  Map.get(params, "type", "original")
    ratio = case type do
      "thumb" -> :thumb
      "mid" -> :mid
      "original" -> :original
    end

    media = GroupMediaRepo.get(id) |> IO.inspect
    data =  File.cwd! <> (Totem.Media.url({media.media, media}, ratio) |> String.replace(~r/\?[a-z0-9=]+/, ""))
    |> File.read!

    conn
    |> put_resp_content_type("image/png")
    |> send_resp(200, data)
  end
end
