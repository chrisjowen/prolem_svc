defmodule Totem.AuthController do
  use TotemWeb, :controller
  plug Ueberauth

  alias Totem.UserRepo
  @completion_url Application.get_env(:totem, Totem.AuthController)[:completion_url]

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> json(%{status: to_string(fails)})
  end


  def callback(%{assigns: %{ueberauth_auth: %{provider: provider} = auth}} = conn,  params) do
    with {:ok, user} <- get_or_create_user(provider, params, auth),
         {:ok, token, _claims} <- Totem.Guardian.encode_and_sign(user) do
      conn |> redirect(external: "#{@completion_url}#{token}")
    end
  end

  defp get_or_create_user(:facebook, params, auth) do
    case UserRepo.get_by_ext_ref("Facebook", auth.uid) do
      nil -> create_user(:facebook, params, auth)
      user -> {:ok, user}
    end
  end

  defp create_user(:facebook, _, auth) do
    info = auth.info
    raw = auth.extra.raw_info
    name_parts = String.split(info.name, " ")

    credentials = %{
      "token" => auth.credentials.token,
      "ext_ref" => raw.user["id"],
      "provider" => "Facebook"
    }

    user = %{
      "name" => List.first(name_parts),
      "last_name" => List.last(name_parts),
      "email" => info.email,
      "profile_pic" => info.image
    }

    with {:ok, %{user: user}} <- UserRepo.insert_with_creds(user, credentials) do
      {:ok, user}
    end
  end
end
