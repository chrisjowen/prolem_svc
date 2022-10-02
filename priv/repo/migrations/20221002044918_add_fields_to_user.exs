defmodule Totem.Repo.Migrations.AddFieldsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :nickname, :string
      add :nationality, :string
      add :dob, :date
      add :avatar_id, :uuid
      add :avatar, :text
      remove :profile_pic
    end
  end
end
