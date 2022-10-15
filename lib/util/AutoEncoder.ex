defmodule Modules do
  alias Totem.Schema

  @modules [
    {Schema.Group, []},
    {Schema.Event, []},
    {Schema.Tag, []},
    {Schema.GroupChat, []},
    {Schema.GroupMedia, []},
    {Schema.GroupType, []},
    {Schema.EventType, []},
    {Schema.GroupInvite, []},
    {Schema.GroupMember, []},
    {Schema.ContactInvite, []},
    {Schema.UserFollow, []},
    {Schema.Notification, []},
    {Schema.UserFriendRequest, []},
    {Scrivener.Page, []},
    {Schema.UserFollow, []},
    {Schema.User, [:credentials]},
  ]


  # def schema_modules() do
  #   with {:ok, list} <- :application.get_key(:totem, :modules) do
  #     list
  #     # |> Enum.filter(fn module ->
  #     #   parts = module |> Module.split
  #     #   length(parts) > 2 && Enum.take(parts, 2) == ["Totem.Schema"]
  #     # end)
  #     # |> Enum.map(fn  {&1, []})
  #   end
  # end



  def modules, do:  @modules
end


Enum.map(Modules.modules, fn {module, strip} ->
  defimpl Jason.Encoder, for: module do
    def encode(schema, options) do
      stripped = MapUtil.from_struct(schema, unquote(Modules.modules))

      stripped
      |> Map.take(Map.keys(stripped))
      |> Jason.Encoder.Map.encode(options)
    end
  end
end)
