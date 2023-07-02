defmodule ProblemService.Workers.SchemaUpdatedWorker do
  use Que.Worker, concurrency: 50
  require Logger
  import Ecto.Query
  alias ProblemService.Web.Endpoint
  alias ProblemService.Eventing.Repo
  alias ProblemService.Schema
  alias ProblemService.Services.NotificationService

  def perform([%Schema.Notification{} = notification, _mode]) do
    send_notification_email(notification)
  end

  def perform([%Schema.User{} = user, :insert]) do
    auto_add_to_problems(user)
  end

  def perform([%Schema.ProblemUser{} = problem_user, mode]) do
    problem_user = Repo.preload(problem_user, [:problem, :member])

    case problem_user.status do
      "invited" ->
        notify(:invited, problem_user.member_id, problem_user)

      "requested" ->
        notify(:requested, problem_user.problem.user_id, problem_user)

        problem =
          problem_user.problem
          |> Repo.preload(:problem_users)

        problem.problem_users
        |> Enum.filter(fn pu -> pu.status == "active" end)
        |> Enum.each(fn pu ->
          notify(:requested, pu.member_id, problem_user)
        end)

      "active" ->
        notify(:active, problem_user.problem.user_id, problem_user)

        problem =
          problem_user.problem
          |> Repo.preload(:problem_users)

        problem.problem_users
        |> Enum.filter(fn pu -> pu.status == "active" end)
        |> Enum.each(fn pu ->
          notify(:requested, pu.member_id, problem_user)
        end)
    end
  end

  def perform([%Schema.ProblemInvite{email: email} = invite, :insert]) when not is_nil(email) do
    send_invite_email(invite)
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

  def perform(args) do
    IO.inspect("I HIT CATCHALL LAND #{inspect(args)}")
  end

  def notify_all(problem_id, mode, entity) do
    problem =
      Repo.get!(Schema.Problem, problem_id)
      |> Repo.preload([:problem_followers, :problem_users])

    follower_ids =
      problem.problem_followers
      |> Enum.map(& &1.user_id)

    member_ids =
      problem.problem_users
      |> Enum.map(& &1.member_id)

    updater_id = entity.updated_by_id || entity.user_id

    if(problem.user_id != updater_id) do
      notify(mode, problem.user_id, entity)
    end

    (follower_ids ++ member_ids)
    |> Enum.uniq()
    |> Enum.filter(fn id -> id != updater_id end)
    |> Enum.each(&notify(mode, &1, entity))
  end

  def notify(mode, to_id, entity) do
    type = entity.__struct__ |> Module.split() |> List.last() |> String.downcase()

    notification =
      Schema.Notification.changeset(%{
        type: type,
        action: Atom.to_string(mode),
        to_id: to_id,
        by_id: entity.updated_by_id || entity.user_id,
        item: Util.MapUtil.from_struct(entity)
      })
      |> Repo.insert!()

    Endpoint.broadcast!("user:#{notification.to_id}", "notification", %{})
  end

  def send_notification_email(%Schema.Notification{} = notification) do
    notification
    |> Repo.preload([:to, :by])
    |> ProblemService.UserEmail.notification()
    |> ProblemService.Mailer.deliver_now()
  end

  def send_invite_email(%Schema.ProblemInvite{} = invite) do
    invite
    |> Repo.preload([:problem, :user])
    |> ProblemService.UserEmail.invite()
    |> ProblemService.Mailer.deliver_now()
  end

  def auto_add_to_problems(%Schema.User{} = user) do
    email = user.email

    q =
      from pi in Schema.ProblemInvite,
        where: pi.email == ^email

    invites = Repo.all(q)

    invites
    |> Enum.each(fn invite ->
      Repo.insert!(%Schema.ProblemUser{
        problem_id: invite.problem_id,
        member_id: user.id,
        user_id: invite.user_id,
        status: "active"
      })
    end)
  end
end
