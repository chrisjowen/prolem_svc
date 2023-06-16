defmodule ProblemService.Schema.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :actions, {:array,:map}
    field :content, :string
    field :read, :boolean, default: false
    field :title, :string
    field :type, :string
    belongs_to :to, ProblemService.Schema.User
    timestamps()
  end

  @doc false
  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:type, :content, :title, :read, :to_id, :content, :actions])
    |> validate_required([:type, :content, :title, :read, :to_id, :content, :actions])
  end
end
