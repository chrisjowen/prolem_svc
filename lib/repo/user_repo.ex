defmodule ProblemService.UserRepo do
  use ProblemService.SchemaRepo, schema: ProblemService.Schema.User


  def login(email, password) do
    user = @this |> with_username(email) |> one()
    case user do
      nil -> {:error, "User not found"}
      _ ->  user
    end
  end

  defp with_username(user, email) do
    from u in user,
      where: u.email == ^email
  end

end
