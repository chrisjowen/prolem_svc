defmodule Totem.EventController do
  use Totem.BaseController
  alias Totem.EventRepo


  def index(conn, %{"id" => id}) do
    json(conn, EventRepo.get(id, []))
  end

  def search(conn, %{"lat" => lat, "lng" => lng} = params) do
    lat = String.to_float(lat)
    lng = String.to_float(lng)

    point = %Geo.Point{coordinates: {lng, lat}}

    results =
      EventRepo.within_distance(point, 3000)
      |> EventRepo.with_order_latest()
      |> EventRepo.all(params, [])
    json(conn, results)
  end

  def create(conn, params) do
    with {:ok, event} <- EventRepo.insert(params) do
      json(conn, event)
    end
  end

end
