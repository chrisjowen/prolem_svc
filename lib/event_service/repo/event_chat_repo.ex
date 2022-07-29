defmodule EventService.EventChatRepo do
  use EventService.SchemaRepo, schema: EventService.Schema.EventChat


  def event_latest(event_id) do
      Repo.all(from c in EventChat,
        where: c.event_id == ^event_id,
        order_by: [asc: c.inserted_at]
      ) |> Repo.preload([:user])
  end

end
