defmodule EventService.PageControllerTest do
  use EventService.DataCase
  alias EventService.Schema
  alias EventService.Repo


  @tag wip: true
  test "A simple test" do
    EventService.EventMediaRepo.all()
    |> IO.inspect()
  end
end
