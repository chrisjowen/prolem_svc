defmodule Totem.CredentialRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.Credential

  def with_ext_ref(ref), do: with_ext_ref(@this, ref)
  def with_ext_ref(query, ref) do
    from q in query,
    where: q.ext_ref == ^ref
  end


end
