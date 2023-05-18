defmodule Modules do
  alias ProblemService.Schema

  @modules [
    {Schema.Idea, []},
    {Schema.Problem, []},
    {Schema.ProblemFollower, []},
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


  # def schema_modules() do
  #   with {:ok, list} <- :application.get_key(:problem_service, :modules) do
  #     list
  #     # |> Enum.filter(fn module ->
  #     #   parts = module |> Module.split
  #     #   length(parts) > 2 && Enum.take(parts, 2) == ["ProblemService.Schema"]
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
