defmodule Totem.Repo.Migrations.EncryptExitingPasswords do
  use Ecto.Migration
  alias Totem.CredentialRepo
  alias Totem.Schema.Credential

  def change do

    CredentialRepo.all()
    |> Enum.filter(fn c -> c.password != nil end)
    |> Enum.map(fn c ->
      CredentialRepo.update!(Credential.changeset(c, %{"password" => c.password}))
    end)

  end
end
