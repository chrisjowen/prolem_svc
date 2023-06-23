defmodule ProblemService.UserProfileController do
  use ProblemService.BaseController, schema: ProblemService.Schema.UserProfile
  import Guardian.Plug
  alias ProblemService.Schema.UserProfile

  plug :check_create_permission when action in [:create]
  plug :check_update_permission when action in [:update, :delete]

  def check_update_permission(conn, _) do
    profile = UserProfile |> Repo.get(conn.params["id"])

    with :ok <-
           Bodyguard.permit(
             UserProfile,
             Phoenix.Controller.action_name(conn),
             current_resource(conn),
             profile
           ) do
      conn
    end
  end

  def check_create_permission(conn, _) do
    with :ok <-
           Bodyguard.permit(
             UserProfile,
             :create,
             current_resource(conn),
             conn.params
           ) do
      conn
    end
  end



end
