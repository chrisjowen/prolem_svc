defmodule Totem.PageControllerTest do
  use Totem.DataCase
  alias Totem.Schema
  alias Totem.Repo


  @tag wip: true
  test "A simple test" do
    Totem.GroupMediaRepo.all()
    |> IO.inspect()
  end
end
