defmodule EventService.UserRepo do
  use EventService.SchemaRepo, schema: EventService.Schema.User
  alias Ecto.Multi
  alias EventService.Schema.Credential


  # Queries
  defp with_username(query, username) do
    from u in query,
    join: c in Credential, on: c.user_id == u.id,
    where: c.username == ^username and c.provider == "Password"
  end

  defp with_ext_ref(query, provider, ext_ref) do
    from u in query,
    join: c in Credential, on: c.user_id == u.id,
    where: c.ext_ref == ^ext_ref  and c.provider == ^provider
  end


  def get_by_username(username), do: Repo.one(with_username(@this, username))
  def get_by_ext_ref(provider, ext_ref), do: Repo.one(with_ext_ref(@this, provider, ext_ref))

  def insert_with_creds(user, credentials) do
    IO.inspect(user)
    IO.inspect(credentials)

    Multi.new()
    |> Multi.insert(:user, @this.changeset(%@this{}, user))
    |> Multi.insert(:credentials, fn %{user: user} ->
      Credential.changeset(Map.put(credentials, "user_id", user.id))
    end)
    |> Repo.transaction()
    |> IO.inspect
  end

end
