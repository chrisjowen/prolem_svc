defmodule ProblemService.Public.LoginController do
  use ProblemService.BaseController
  alias ProblemService.Guardian
  alias ProblemService.UserRepo

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- UserRepo.login(email, password) do
      # TODO: Check password
      {:ok, token, claims} =  ProblemService.Guardian.encode_and_sign(user)
      json(conn, %{token: token, claims: claims, user: user})
    end
  end
end
