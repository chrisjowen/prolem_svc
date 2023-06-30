defmodule ProblemScv.Integration.ParamQueryGenerator do
  use ProblemService.DataCase
  alias ProblemService.Schema

  import Ecto.Query

  @tag :integration
  test "can_query_map" do
    idea =
      Schema.Idea.changeset(%Schema.Idea{}, %{
        title: "test",
        description: "test",
        sectors: [
          %{
            "id" => 1
          }
        ]
      })
      |> Repo.insert!()

    # query =
    #   from i in Schema.Idea,
    #     where: i.sectors == ^[%{id: 1}]


    query =
      from i in Schema.Idea,
        where: i.sectors == ^[%{id: 1}] or i.sectors == ^[%{id: 2}]

    assert [idea] == Repo.all(query)
  end
end
