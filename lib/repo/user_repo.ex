defmodule ProblemService.UserRepo do
  use ProblemService.SchemaRepo, schema: ProblemService.Schema.User
  alias Ecto.Multi
  alias ProblemService.Schema.Credential

  def get_by_username(username) do
    @this |> with_username(username) |> one()
  end

  def get_by_ext_ref(provider, ext_ref) do
    @this |> with_ext_ref(provider, ext_ref) |> one()
  end

  def insert_with_creds(user, credentials) do
    Multi.new()
    |> Multi.insert(:user, @this.changeset(%@this{}, user))
    |> Multi.insert(:credentials, fn %{user: user} ->
      Credential.changeset(Map.put(credentials, "user_id", user.id))
    end)
    |> Repo.transaction()
  end

  # TODO: PG FT search ecto or move to elastic https://medium.com/socialcom/postgresql-full-text-search-using-ecto-e3f254267208
  def search(q, preloads \\ []), do: with_search(@this, q) |> all(%{}, preloads)

  # Queries

  def with_search(query, q) do
    term =  "%" <> q <> "%"

    from u in query,
    where: like(u.name, ^term)
      or like(u.last_name, ^term)
      or like(u.email, ^term)

  end

  defp with_username(query, username) do
    from u in query,
      join: c in Credential,
      on: c.user_id == u.id,
      where: c.username == ^username and c.provider == "Password",
      select: {u, c}
  end

  defp with_ext_ref(query, provider, ext_ref) do
    from u in query,
      join: c in Credential,
      on: c.user_id == u.id,
      where: c.ext_ref == ^ext_ref and c.provider == ^provider,
      select: {u, c}
  end
end
