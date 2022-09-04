defmodule Totem.Schema.ContactInvite do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema


  schema "contact_invites" do
    field :contact_email, :string
    field :contact_fb_id, :string
    field :contact_name, :string
    field :contact_number, :string
    field :status, :string, default: "OPEN"
    belongs_to :user, Schema.User

    timestamps()
  end

  @doc false
  def changeset(contact_invite, attrs) do
    contact_invite
    |> cast(attrs, [:contact_number, :contact_email, :contact_name, :contact_fb_id, :status, :user_id])
    |> validate_required([:user_id , :status])
  end
end
