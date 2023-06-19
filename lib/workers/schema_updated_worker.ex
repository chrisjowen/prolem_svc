defmodule ProblemService.Workers.SchemaUpdatedWorker do
  use Que.Worker, concurrency: 50
  require Logger

  alias ProblemService.Web.Endpoint
  alias ProblemService.Eventing.Repo
  alias ProblemService.Schema
  alias ProblemService.Services.NotificationService


  def perform([%Schema.Notification{} = notification, mode]) do
    send_notification_email(notification)
  end


  def perform([%Schema.Problem{} = problem, mode]) do
    notify_all(problem.id, mode, problem)
  end

  def perform([%Schema.Discussion{} = entity, mode]) do
    notify_all(entity.problem_id, mode, entity)
  end

  def perform([%Schema.Link{} = entity, mode]) do
    notify_all(entity.problem_id, mode, entity)
  end

  def perform([%Schema.Page{} = entity, mode]) do
    notify_all(entity.problem_id, mode, entity)
  end

  def perform([%Schema.Answer{} = entity, mode]) do
    entity = entity |> Repo.preload([:discussion])
    notify_all(entity.discussion.problem_id, mode, entity)
  end

  def notify_all(problem_id, mode, entity) do
    problem = Repo.get!(Schema.Problem, problem_id)
      |> Repo.preload([:problem_followers, :problem_users])

    follower_ids = problem.problem_followers
      |> Enum.map(&(&1.user_id))

    member_ids = problem.problem_users
      |> Enum.map(&(&1.member_id))

    updater_id = entity.updated_by_id || entity.user_id

    (follower_ids ++ member_ids)
    |> Enum.uniq()
    # |> Enum.filter(fn id -> id != updater_id end)
    |> Enum.each(&notify(mode, &1, entity))
  end

  def notify(mode, to_id, entity) do
    type = entity.__struct__ |> Module.split() |> List.last() |> String.downcase()

    Schema.Notification.changeset(%{
      type: type,
      action: Atom.to_string(mode),
      to_id: to_id,
      by_id: entity.updated_by_id || entity.user_id,
      item: Util.MapUtil.from_struct(entity),
    })
    |> Repo.insert()
    |> IO.inspect
  end

  def send_notification_email(%Schema.Notification{} = notification) do
    notification
    |> Repo.preload([:to, :by])
    |> ProblemService.UserEmail.notification()
    |> ProblemService.Mailer.deliver_now()


  end

  def perform(args) do
    IO.inspect("I HIT CATCHALL LAND #{inspect(args)}")
  end
end
