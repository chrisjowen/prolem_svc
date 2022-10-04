defmodule Totem.GroupController do
  use Totem.BaseController
  alias Totem.GroupRepo


  def index(conn, %{"id" => id}) do
    json(conn, GroupRepo.get(id, [[chats: :user], :user, :media, :type, :members]))
  end



  def search(conn, %{"lat" => lat, "lng" => lng} = params) do
    lat = String.to_float(lat)
    lng = String.to_float(lng)
    filters = params["filters"] || %{}
    point = %Geo.Point{coordinates: {lng, lat}}
    # TODO: Totally ineffictient getting all members etc in call
    results =
      GroupRepo.within_distance(point, 1)
      |> GroupRepo.with_order_latest()
      |> GroupRepo.with_active()
      |> GroupRepo.with_filters(filters)
      |> GroupRepo.all(params, [:type, :user, :members])
    json(conn, results)
  end

  def search(conn, params) do
    search(conn, Map.merge(params, %{
      "lat" => "1.3294294462868943",
      "lng" => "103.9150886511081",
    }))
  end




  def create(conn, params) do
    with {:ok, %{group: group}} <- GroupRepo.insert(params) do
      json(conn, group)
    end
  end

end
