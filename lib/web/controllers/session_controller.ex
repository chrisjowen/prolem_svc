defmodule Totem.SessionController do
  use Totem.BaseController
  alias Totem.UserRepo
  alias Totem.CredentialRepo

  def login(conn, %{"fbToken" => token, "fbRef" => ref}) do
    with {:ok, {user, _credentials}} <- UserRepo.get_by_ext_ref("Facebook", ref),
         {:ok, token, _claims} <- IO.inspect(Totem.Guardian.encode_and_sign(user) ) do
      conn
      |> json(%{
        token: token,
        user: user
      })
    # else
    #   bad ->
    #     IO.inspect(bad)
    #     {:unauthorized, :not_found}
    end
  end

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

  def register(conn, %{"email" => email, "password" => password} = params) when not is_nil(password) do
    creds = %{
      "username" => email,
      "password" => password,
      # TODO: Do this properly
      "salt" => "Somerandomsalt"
    }

    with {:ok, %{user: user}} <- UserRepo.insert_with_creds(params, creds),
         {:ok, token, _claims} <- Totem.Guardian.encode_and_sign(user) do
      conn
      |> json(%{
        token: token,
        user: user
      })

      else
        error -> IO.inspect(error)

    end
  end

  def register(conn, %{"ext_ref" => ref, "ext_token" => token} = params) do
    # TODO: Confirm token
    creds = %{
      "token" => token,
      "ext_ref" => ref,
      "provider" => "Facebook"
    }

    with :ok <- enusre_no_duplicate_credential(creds),
         {:ok, %{user: user}} <- UserRepo.insert_with_creds(params, creds),
         {:ok, token, _claims} <- Totem.Guardian.encode_and_sign(user) do
      conn
      |> json(%{
        token: token,
        user: user
      })
    end
  end



  defp enusre_no_duplicate_credential(%{"ext_ref" => ref}) do
    case CredentialRepo.with_ext_ref(ref) |> CredentialRepo.all() do
      items when items == [] -> :ok
      _ -> {:error, {:login, :duplicate_external_ref}}
    end
  end

  # Nonsense
  def check_password(user, credentials, password) do
    cond do
      credentials.password == password -> Totem.Guardian.encode_and_sign(user)
      true -> {:unauthorized, :password_failed}
    end
  end
end
