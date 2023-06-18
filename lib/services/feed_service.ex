defmodule ProblemService.Services.FeedService do
  require Logger
  alias ProblemService.Services.NotificationService.ProblemFeedItem
  alias ProblemService.Schema.Notification
  alias ProblemService.Repo
  alias ProblemService.Schema.{Problem, Page, Link, Discussion, Answer}
  import Ecto.Query


  defmodule ProblemFeedItem do
    defstruct who: nil,
              type: nil,
              item: nil,
              when: nil,
              mode: nil

    def create(item) do
      type = item.__struct__ |> Module.split() |> List.last() |> String.downcase()

      %ProblemFeedItem{
        who: item.user,
        type: type,
        when: item.updated_at,
        item: item,
        mode: if(item.updated_by !=nil, do: "updated", else: "created")
      }
    end
  end


  def problem_feed(problem_id) do
    load_problem_feed(problem_id)
  end

  defp load_problem_feed(problem_id) do
    problem = Repo.get!(Problem, problem_id) |> Repo.preload([:user, :updated_by])

    pages =
      Repo.all(
        from p in Page,
          where: p.problem_id == ^problem_id,
          limit: 10,
          order_by: {:asc, :updated_at},
          preload: [:updated_by, :user]
      )

    links =
      Repo.all(
        from p in Link,
          where: p.problem_id == ^problem_id,
          limit: 10,
          order_by: {:asc, :updated_at},
          preload: [:updated_by, :user]
      )

    discussions =
      Repo.all(
        from p in Discussion,
          where: p.problem_id == ^problem_id,
          limit: 10,
          order_by: {:asc, :updated_at},
          preload: [:updated_by, :user]
      )

    discussion_ids = Enum.map(discussions, fn d -> d.id end)

    answers =
      Repo.all(
        from p in Answer,
          where: p.discussion_id in ^discussion_ids,
          limit: 10,
          order_by: {:asc, :updated_at},
          preload: [:updated_by, :user, :discussion]
      )

    feed =
      ([problem] ++ pages ++ links ++ discussions ++ answers)
      |> Enum.sort_by(fn p -> p.updated_at end,  :desc)
      |> Enum.take(20)
      |> Enum.map(&ProblemFeedItem.create(&1))


    {:ok, feed}
  end


end
