defmodule EventService.EventRepo do
  use EventService.SchemaRepo, schema: EventService.Schema.Event
  import Geo.PostGIS
  alias Ecto.Multi
  alias EventService.Schema.EventTag
  alias EventService.Schema
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

  def get_with_expansions(id, _expansions) do
    Repo.one(
      from e in Schema.Event,
        as: :event,
        join: c in assoc(e, :chats),
        inner_lateral_join:
          top_five in subquery(
            from Schema.EventChat,
              where: [event_id: parent_as(:event).id],
              limit: 4,
              select: [:id]
          ),
        on: top_five.id == c.id,




        where: e.id == ^id,
        preload: [{:chats, {c, :user}}, :user, :media]
    )
  end
end
