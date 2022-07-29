defmodule EventService.EventRepo do
  use EventService.SchemaRepo, schema: EventService.Schema.Event
  import Geo.PostGIS
  alias Ecto.Multi
  alias EventService.Schema.EventTag

  def within_distance(point, distance), do: within_distance(@this, point, distance)

  def within_distance(query, point, distance) do
    from q in query,
      where: st_distance(q.location, ^point) < ^distance
  end

  def insert(params) do
    Multi.new()
    |> Multi.insert(:event, @this.changeset(%@this{}, params))
    |> Multi.insert_all(:tags, EventTag, fn %{event: event} ->
      params["tags"] |> Enum.map(&%{event_id: event.id, tag_id: &1})
    end)
    |> Repo.transaction()
  end
end
