defmodule ProblemService.Repo.Migrations.ChangeProfileEducation do
  use Ecto.Migration

  def change do
    rename table(:user_profiles), :hightst_education, to: :education
  end
end
