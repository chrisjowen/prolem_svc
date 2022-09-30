defmodule Totem.SessionController do
  use Totem.BaseController
  alias Totem.UserRepo

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, {user, credentials}} <- UserRepo.get_by_username(username),
         {:ok, token, _claims} <- check_password(user, credentials, password) do
      conn
      |> json(%{
        token: token,
        user: user
      })
    end
  end


  def register(conn, %{"username" => username, "password" => password} = params) do
    creds = %{
      "username" => username,
      "password" => password,
      "salt" => "Somerandomsalt" # TODO: Do this properly
    }

    with {:ok, %{user: user}} <- UserRepo.insert_with_creds(params, creds),
         {:ok, token, _claims} <-  Totem.Guardian.encode_and_sign(user) do
      conn
      |> json(%{
        token: token,
        user: user
      })
    end
  end


# Nonsense
  def check_password(user, credentials, password) do
    cond do
      credentials.password == password ->  Totem.Guardian.encode_and_sign(user)
      true -> {:unauthorized, :password_failed}
    end
  end
end
