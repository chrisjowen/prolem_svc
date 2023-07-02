defmodule ProblemService.Schema.UserProfile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_profiles" do
    field :accomplishments, :string
    field :anything_else, :string
    field :country, :string
    field :education, :string
    field :interests, {:array, :string}, default: []
    field :languages, {:array, :map}, default: []
    field :intro, :string
    field :linkedin, :string
    field :open_to_invites, :boolean, default: true
    field :skills, {:array, :string}, default: []
    field :start_working, :naive_datetime
    field :technical, :boolean, default: false
    field :twitter, :string
    belongs_to :user, ProblemService.Schema.User
    timestamps()
  end

  @doc false
  def changeset(user_profile, attrs) do
    required = [
      :user_id
    ]

    additional = [
      :intro,
      :country,
      :languages,
      :linkedin,
      :accomplishments,
      :education,
      :twitter,
      :technical,
      :skills,
      :interests,
      :start_working,
      :anything_else,
      :open_to_invites
    ]

    user_profile
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end


  def authorize(:create, user, %{params: %{"user_id" =>  user_id}}) do
    user.id == user_id
  end

  def authorize(action, user, profile) when action in [:update, :delete] do
    user.id == profile.user_id
  end


end
