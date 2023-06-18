defmodule ProblemService.Schema.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :content, :string
    field :title, :string
    field :read, :boolean, default: false
    field :type, :string
    field :action, :string
    field :item, :map
    belongs_to :by, ProblemService.Schema.User
    belongs_to :to, ProblemService.Schema.User
    timestamps()
  end


  @doc false
  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)
  def changeset(notification, attrs) do

    required =  [
      :action,
      :type,
      :to_id
    ]

    additional = [
      :read,
      :item,
      :by_id,
      :content,
      :title
    ]

    notification
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end
end
