defmodule Totem.EventController do
  use Totem.BaseController
  alias Totem.EventRepo

  @default_filters %{
    "lat" => "1.3294294462868943",
    "lng" => "103.9150886511081",
    "filters" => %{}
  }

  def index(conn, %{"id" => id}) do
    json(conn, EventRepo.get(id, [:type, :dates]))
  end

  def banner(conn, %{"id" => id} = params) do
    type =  Map.get(params, "type", "pin")
    ratio = case type do
      "card" -> :card
      "pin" -> :pin
      "original" -> :original
    end

    event = EventRepo.get(id)
    data =  File.cwd! <> (Totem.EventMedia.url({event.banner, event}, ratio) |> String.replace(~r/\?[a-z0-9=]+/, ""))
    |> File.read!

    conn
    |> put_resp_content_type("image/png")
    |> send_resp(200, data)
  end

  def search(conn, %{"lat" => lat, "lng" => lng, "filters" => filters} = params) do
    lat = lat |>  String.to_float()
    lng = lng |> String.to_float()
    distance = Map.get(params, "distance", "500000") |> String.to_integer
    point = %Geo.Point{coordinates: {lng, lat}}

    results =
     EventRepo.within_distance(point, distance)
     |> EventRepo.with_filters(filters)
     |> EventRepo.paginate(params, [:type, :dates])
    json(conn, results)
  end

  def search(conn, params), do: search(conn, Map.merge(params, @default_filters ))

  def create(conn, %{"body" => body} = params ) do
    attrs = Jason.decode!(body)
    lat = attrs["location"]["lat"]
    lng = attrs["location"]["lng"]
    point = %Geo.Point{coordinates: {lng, lat}}
    attrs = Map.put(attrs, "banner", Map.get(params, "banner"))
    attrs = Map.put(attrs, "location", point)
    with {:ok, %{event: event}} <- EventRepo.insert(attrs) do
      json(conn, event)
    end
  end

end
