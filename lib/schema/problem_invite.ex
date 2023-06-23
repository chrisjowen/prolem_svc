defmodule ProblemService.Schema.ProblemInvite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "problem_invites" do
    field :email, :string
    field :identifier, :string, default: Ecto.UUID.generate()
    field :type, :string, default: "email"
    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :user, ProblemService.Schema.User
    field :used, :boolean, default: false
  end

  @doc false
  def changeset(external_invite, attrs) do
    default = [:type, :identifier, :problem_id, :user_id]

    {additional, required} =
      case attrs["type"] do
        "email" -> {[], default ++ [:email]}
        _ -> {[:email], default}
      end

    external_invite
    |> cast(attrs, additional ++ required)
    |> validate_required(required)
  end
end
