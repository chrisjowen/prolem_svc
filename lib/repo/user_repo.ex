defmodule Totem.UserRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.User
  alias Ecto.Multi
  alias Totem.Schema.Credential

  def get_by_username(username) do
    @this |> with_username(username) |> Repo.one()
  end

  def get_by_ext_ref(provider, ext_ref) do
    @this |> with_ext_ref(provider, ext_ref) |> Repo.one()
  end

  def insert_with_creds(user, credentials) do
    Multi.new()
    |> Multi.insert(:user, @this.changeset(%@this{}, user))
    |> Multi.insert(:credentials, fn %{user: user} ->
      Credential.changeset(Map.put(credentials, "user_id", user.id))
    end)
    |> Repo.transaction()
  end

  # Queries
  defp with_username(query, username) do
    from u in query,
      join: c in Credential,
      on: c.user_id == u.id,
      where: c.username == ^username and c.provider == "Password"
  end

  defp with_ext_ref(query, provider, ext_ref) do
    from u in query,
      join: c in Credential,
      on: c.user_id == u.id,
      where: c.ext_ref == ^ext_ref and c.provider == ^provider
  end
end
