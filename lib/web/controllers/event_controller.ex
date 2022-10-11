defmodule Totem.EventController do
  use Totem.BaseController
  alias Totem.EventRepo


  def index(conn, %{"id" => id}) do
    json(conn, EventRepo.get(id, []))
  end


  def banner(conn, %{"id" => id} = params) do
    type =  Map.get(params, "type", "original")
    ratio = case type do
      "thumb" -> :thumb
      "mid" -> :mid
      "original" -> :original
    end

    event = EventRepo.get(id)
    data =  File.cwd! <> (Totem.EventMedia.url({event.banner, event}, ratio) |> String.replace(~r/\?[a-z0-9=]+/, ""))
    |> File.read!

    conn
    |> put_resp_content_type("image/png")
    |> send_resp(200, data)
  end


  def search(conn, %{"lat" => lat, "lng" => lng} = params) do
    lat = String.to_float(lat)
    lng = String.to_float(lng)

    point = %Geo.Point{coordinates: {lng, lat}}

    results =
      # EventRepo.within_distance(point, 3000)

     EventRepo.with_order_latest()
      |> EventRepo.all(params, [])
    json(conn, results)
  end

  def search(conn, params) do
    search(conn, Map.merge(params, %{
      "lat" => "1.3294294462868943",
      "lng" => "103.9150886511081",
    }))
  end

  def create(conn, %{"body" => body} = params ) do
    attrs = Jason.decode!(body)
    lat = attrs["location"]["lat"]
    lng = attrs["location"]["lng"]
    point = %Geo.Point{coordinates: {lng, lat}}
    attrs = Map.put(attrs, "banner", Map.get(params, "banner"))
    attrs = Map.put(attrs, "location", point)
    with {:ok, event} <- EventRepo.insert(attrs) do
      json(conn, event)
    end
  end

end
