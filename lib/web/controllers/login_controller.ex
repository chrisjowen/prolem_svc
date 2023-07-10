defmodule ProblemService.LoginController do
  use ProblemService.BaseController
  alias ProblemService.Guardian
  alias ProblemService.Schema.User
  alias ProblemService.Schema.UserProfile

  def login(conn, %{"email" => email, "password" => password}) do
    user =
      User
      |> User.Queries.with_username(email)
      |> Repo.one()


    cond do
      user == nil ->
        {:error, "Invalid username"}

      user.password != nil and Comeonin.Ecto.Password.valid?(password, user.password) ->
        {:ok, token, claims} = Guardian.encode_and_sign(user)
        json(conn, %{token: token, claims: claims, user: user})

      true ->
        {:error, "Invalid password"}
    end
  end

  def register(conn, params) do
    with {:ok, user} <- Repo.change(User, params) |> Repo.insert(),
         {:ok, profile} <-
           Repo.change(UserProfile, %{
             "user_id" => user.id,
             "intro" => "I'm new to CrowdSolve!",
             "country" => "sg"
           })
           |> Repo.insert(),
         {:ok, token, claims} = Guardian.encode_and_sign(user) do
      json(conn, %{token: token, claims: claims, user: user})
    end
  end
end
