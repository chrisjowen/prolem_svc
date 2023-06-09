defmodule ProblemService.Schema.Announcement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "announcements" do
    field :links, :map
    field :message, :string
    field :title, :string
    field :type, :string

    belongs_to :user, ProblemService.Schema.User
    belongs_to :solution, ProblemService.Schema.Solution

    timestamps()
  end

  @doc false
  def changeset(announcement, attrs) do
    required = [:type, :message, :title, :links, :user_id, :solution_id]

    announcement
    |> cast(attrs, required)
    |> validate_required(required)
  end
end
