defmodule ProblemService.Services.NotificationService do
  require Logger
  alias ProblemService.Schema.Notification
  alias ProblemService.Repo

  def notify(:update, user, problem) do
    Notification.changeset(%{
      type: "problem",
      action: "updated",
      to_id: user.id,
      by_id: problem.updated_by_id || problem.user_id,
      item: Util.MapUtil.from_struct(problem),
    })
    |> Repo.insert()
  end

  def notify(_, _, _ ) do
    Logger.info("Nobody to notify")
  end

end
