defmodule ProblemService.Repo.Migrations.AddBannerImageToProduct do
  use Ecto.Migration

  def change do
    alter table(:problems) do
      add :banner_image, :string
    end
  end
end
