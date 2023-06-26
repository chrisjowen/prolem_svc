defmodule ProblemService.OAuthController do
  use ProblemService.Web, :controller
  alias ProblemService.Repo
  alias ProblemService.Schema.User

  plug Ueberauth


  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    conn
    |> redirect(external: System.get_env("UI_BASE_URL") <> "/login?error=#{failure.reason}")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect(auth)

    user =
      case Repo.get_by(User, ext_id: auth.uid, ext_ref: Atom.to_string(auth.provider)) do
        nil -> get_or_create_user(auth)
        user -> user
      end

    {:ok, token, _} = user |> ProblemService.Guardian.encode_and_sign() |> IO.inspect()

    conn
    |> redirect(external: System.get_env("UI_BASE_URL") <> "/login/cb/#{token}")
  end

  defp get_or_create_user(auth = %Ueberauth.Auth{info: %{ email: nil }}), do: create_user(auth)

  defp get_or_create_user(auth = %Ueberauth.Auth{}) do
    case Repo.get_by(User, email: auth.info.email) do
      nil -> create_user(auth)
      user -> maybe_update_user_ext_id(user, auth)
    end
  end

  defp create_user(auth = %Ueberauth.Auth{}) do
    IO.inspect(auth.info)
    name = auth.info.name || "#{auth.info.first_name} #{auth.info.last_name}"
    username = (name |> String.downcase() |> String.replace(" ", "_")) <> "_" <> (Ecto.UUID.generate() |> String.slice(0..5))
    [first_name, lastname | _] = String.split(name, " ")

    User.changeset(%User{}, %{
      "username" => username,
      "name" => auth.info.first_name || first_name,
      "last_name" => auth.info.last_name || lastname,
      "email" => auth.info.email,
      "ext_id" => auth.uid,
      "ext_ref" => Atom.to_string(auth.provider)
    })
    |> Repo.insert!()
  end

  defp maybe_update_user_ext_id(user, auth = %Ueberauth.Auth{}) do
    case user.ext_id do
      nil ->
        User.changeset(user, %{ext_id: auth.uid, ext_ref: "google"})
        |> Repo.update!()

      _ ->
        user
    end
  end
end
