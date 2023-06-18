defmodule ProblemService.Schema.DiscussionReference do
  use Ecto.Schema
  import Ecto.Changeset
  alias Util.EctoUtil

  schema "discussion_references" do
    field :notes, :string
    field :discussion_id, :id
    field :link_id, :id
    field :user_id, :id
  end

  @doc false
  def changeset(discussion_reference, attrs) do
    discussion_reference
    |> cast(attrs, [:notes, :discussion_id, :link_id, :user_id])
    |> validate_required([:notes, :user_id])
    |> EctoUtil.validate_required_inclusion([:discussion_id, :link_id])
  end
end
