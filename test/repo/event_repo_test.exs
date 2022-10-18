defmodule TestRequestValidator do
  import Ecto.Changeset
  import PhoenixApiToolkit.Ecto.Validators
  import PhoenixApiToolkit.GenericRequestValidator

  @schema resource_schema(%{type_id: :integer}, %{start: :date})
  @entity_fields @schema |> get_entity_fields()

  def index_query(attrs) do
    @schema
    |> cast(attrs, @entity_fields)
  end
end

defmodule Totem.EventRepoTest do
  use Totem.DataCase
  alias Totem.EventRepo
  alias Totem.EventTypeRepo

  # @events [
  #   %{
  #     "title" => "Event A",
  #     "description" => "Description A",
  #     "provider" => "ProviderA",
  #     "start" => ~N[2021-01-01 00:00:00],
  #     "ref" => "12345",
  #     "location" => %Geo.Point{coordinates: {103.9150886511081, 1.3294294462868943}}
  #   },
  #   %{
  #     "title" => "Event B",
  #     "description" => "Description B",
  #     "provider" => "ProviderB",
  #     "start" => ~N[2021-03-01 00:00:00],
  #     "ref" => "ABCDE",
  #     "location" => %Geo.Point{coordinates: {103.9150886511081, 1.3294294462868943}}
  #   }
  # ]

  # # setup_all tags do
  # #   pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Totem.Repo, shared: not tags[:async])
  # #   on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)

  # #   {:ok, events: events}
  # # end

  # test "Get all" do
  #   t1 = EventTypeRepo.insert!(%{name: "Type A"})
  #   t2 = EventTypeRepo.insert!(%{name: "Type B"})
  #   [e1, e2] = @events

  #   EventRepo.insert!(Map.merge(e1, %{"type_id" => t1.id}))
  #   EventRepo.insert!(Map.merge(e2, %{"type_id" => t2.id}))
  #   # roles: ["admin", "superadmin"]

  #   EventRepo.with_filters(%{ "type_id" => [t1.id, t2.id], "starts_after" =>  "2022-02-01T00:00:00.575Z"})
  #   |> EventRepo.all()
  #   |> IO.inspect()
  # end

  test "wip" do
    endpoint =
      "https://fcm.googleapis.com/fcm/send/cGuFZUnTpXQ:APA91bF7c2BQ9AEnHUBrXxG8qytxXPgG0_xYKswCNEkRElta_NaZSjs2qVCdhvIYVc0PQNPQ_8w2CMj9rQhbURXL-IwcA7nfdf3bSw_yryaTAbTMTHj116qjnDWvLbZX3ssEMjCtPf12"

    data = ~s({"hello": "elixir"})

    body = %{
      notification: %{
        title: "Notificaiton Title",
        body: "Notificaiton Body",
        # image: notification.image ? notification.image : context.app.settings.image ,
        data: data
      }
    }


    subscription = %{
      keys: %{
        p256dh:
          "BIjVYsVgsCwglwpylljvrerzb3cxeox_c8M87jbIZz7mA37dAjrfnR98Ml384HHsm_4ahA9QHbbBUJz6Mwzwt0w",
        auth: "cNxhufvNqDWs6pgAmxSAAQ"
      },
      endpoint: endpoint
    }

    WebPushEncryption.send_web_push(Jason.encode!(body), subscription) |> IO.inspect()
  end
end
