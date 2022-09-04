defmodule Totem.GroupController do
  use TotemWeb, :controller
  alias Totem.GroupRepo
  import Guardian.Plug


  def index(conn, %{"id" => id} = params) do
    expansions = String.split(Map.get(params, "expansion", ""), ",")
    json(conn, GroupRepo.get_with_expansions(id, expansions))
  end


  def list(conn, %{"lat" => lat, "lng" => lng} = params) do
    lat = String.to_float(lat)
    lng = String.to_float(lng)
    point = %Geo.Point{coordinates: {lng, lat}}

    # TODO: Totally ineffictient getting all members etc in call
    results =
      GroupRepo.within_distance(point, 1)
      |> GroupRepo.all(params, [:type, :user, :members])

    json(conn, results)
  end

  def create(conn, params) do
    user = current_resource(conn)
    params = Map.put(params, "user_id", user.id)
    with {:ok, %{group: group}} <- GroupRepo.insert(params) do
      json(conn, group)
    end
  end



end
