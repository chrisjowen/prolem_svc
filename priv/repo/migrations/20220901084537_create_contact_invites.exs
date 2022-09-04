defmodule Totem.Repo.Migrations.CreateContactInvites do
  use Ecto.Migration

  def change do
    create table(:contact_invites) do
      add :contact_number, :string
      add :contact_email, :string
      add :contact_name, :string
      add :contact_fb_id, :string
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:contact_invites, [:user_id])
  end
end
