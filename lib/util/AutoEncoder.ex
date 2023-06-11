defmodule Modules do
  alias ProblemService.Schema

  @modules [
    {Schema.Idea, []},
    {Schema.Comment, []},
    {Schema.Discussion, []},
    {Schema.Link, []},
    {Schema.Answer, []},
    {Schema.Obstacle, []},
    {Schema.Problem, []},
    {Schema.Follower, []},
    {Schema.Sector, []},
    {Schema.Questionaire, []},
    {Schema.Questionaire.Question, []},
    {Schema.Product, []},
    {Schema.Solution, []},
    {Schema.Stakeholder, []},
    {Schema.Event, []},
    {Schema.Tag, []},
    {Schema.PushSub, []},
    {Scrivener.Page, []},
    {Schema.User, []},
  ]

  def modules, do:  @modules
end


Enum.map(Modules.modules, fn {module, strip} ->
  defimpl Jason.Encoder, for: module do
    def encode(schema, options) do
      stripped = Util.MapUtil.from_struct(schema, unquote(Modules.modules))

      stripped
      |> Map.take(Map.keys(stripped))
      |> Jason.Encoder.Map.encode(options)
    end
  end
end)
