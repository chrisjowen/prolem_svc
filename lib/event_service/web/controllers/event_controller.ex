defmodule EventService.EventController do
  use EventServiceWeb, :controller
  alias EventService.EventRepo
  import Guardian.Plug


  def list(conn, %{"lat" => lat, "lng" => lng} = params) do
    lat = String.to_float(lat)
    lng = String.to_float(lng)
    point = %Geo.Point{coordinates: {lng, lat}}

    results =
      EventRepo.within_distance(point, 100_000)
      |> EventRepo.all(params, [:tags, :user])

    json(conn, results)
  end

  def create(conn, params) do
    user = current_resource(conn)
    params = Map.put(params, "user_id", user.id)
    with {:ok, %{event: event}} <- EventRepo.insert(params) do
      json(conn, event)
    end
  end



end
