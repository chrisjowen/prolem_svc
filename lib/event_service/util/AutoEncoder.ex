defmodule Modules do
  alias EventService.Schema

  @modules [
    {Schema.Event, []},
    {Schema.Tag, []},
    {Schema.EventChat, []},
    {Schema.User, [:credentials]},
  ]

  def modules, do: @modules
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
