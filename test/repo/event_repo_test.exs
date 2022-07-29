defmodule EventService.PageControllerTest do
  use EventService.DataCase
  alias EventService.Schema
  alias EventService.Repo


  test "A simple test" do
    json = """
    { "start": "2022-06-28T11:36:46.596Z", "end": "2022-06-28T11:36:46.596Z", "title": "Test", "description": "Test", "tags": [ 5, 4 ], "location": { "lat": 1.3294457783046707, "lng": 103.91512758155012 }, "radius": 50 }
    """

    attrs = Jason.decode!(json)

    # Schema.Event.changeset(%Schema.Event{}, attrs)
    # |> Repo.insert!()

    EventService.EventRepo.insert(attrs)

    |> IO.inspect()
  end
end
