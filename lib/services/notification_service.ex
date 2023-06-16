defmodule ProblemService.Services.NotificationService do
  require Logger
  alias ProblemService.Schema.Notification
  alias ProblemService.Repo

  def notify(:problem_updated, user, problem) do
    Notification.changeset(%{
      type: "problem_updated",
      title: "Problem Updated",
      actions: [%{
        title: "Show Problem",
        href: "/problems/show/#{problem.id}"
      }],
      to_id: user.id,
      content: "Problem #{problem.title} has been updated"
    })
    |> Repo.insert()
    |> IO.inspect()
  end

  def notify(_, _, _ ) do
    Logger.info("Nobody to notify")
  end

end
