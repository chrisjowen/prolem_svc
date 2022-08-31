defmodule Totem.Schema.GroupTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema
  alias Totem.Schema.GroupTag

  schema "group_tags" do
    belongs_to :group, Schema.Group
    belongs_to :tag, Schema.Tag
  end


  @doc false
  def changeset(attrs), do: changeset(%GroupTag{}, attrs)

  @doc false
  def changeset(event_tag, attrs) do
    event_tag
    |> cast(attrs, [:group_id, :tag_id])
    |> validate_required([:group_id, :tag_id])
  end
end
