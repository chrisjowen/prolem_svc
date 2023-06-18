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
        href: "/problem/show/#{problem.id}"
      }],
      to_id: user.id,
      content: """
        <p>Problem: <strong>#{problem.title}</strong></p>
        <p>Was updated by #{problem.updated_by.name}</p>
      """
    })
    |> Repo.insert()
    |> IO.inspect()
  end

  def notify(_, _, _ ) do
    Logger.info("Nobody to notify")
  end

end
