defmodule ProblemService.Public.LoginController do
  use ProblemService.BaseController
  alias ProblemService.Guardian
  alias ProblemService.UserRepo

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- UserRepo.login(email, password) do

      IO.inspect("VALIDTING PASSWORD")
      Comeonin.Ecto.Password.valid?(password, user.password) |> IO.inspect()

      IO.inspect("END VALIDTING PASSWORD")


      cond do
        Comeonin.Ecto.Password.valid?(password, user.password)   ->
          {:ok, token, claims} =  ProblemService.Guardian.encode_and_sign(user)
          json(conn, %{token: token, claims: claims, user: user})
        true ->
          {:error, "Invalid password"}
      end
      # TODO: Check password

    end
  end

  def register(conn, params) do
    with {:ok, user} <- UserRepo.insert(params) do
      # TODO: Check password
      {:ok, token, claims} =  ProblemService.Guardian.encode_and_sign(user)
      json(conn, %{token: token, claims: claims, user: user})
    end
  end
end
