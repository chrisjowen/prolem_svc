defmodule Totem.FriendRequestRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.UserFriendRequest


  def with_user(user), do: with_user(@this, user)
  def with_user(query, user) do
    from q in query,
      where: q.user_id == ^user.id
  end


end
