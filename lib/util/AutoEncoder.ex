defmodule Modules do
  alias ProblemService.Schema

  @modules [
    {Schema.Idea, []},
    {Schema.Comment, []},
    {Schema.Discussion, []},
    {Schema.Expert, []},
    {Schema.ContributeRequest, []},
    {Schema.Notification, []},
    {Schema.Link, []},
    {Schema.Answer, []},
    {Schema.Obstacle, []},
    {Schema.Vote, []},
    {Schema.Problem, [embed: [:overview]]},
    {Schema.Follower, []},
    {Schema.Sector, [embed: [:description]]},
    {Schema.Questionaire, []},
    {Schema.Questionaire.Question, []},
    {Schema.Product, []},
    {Schema.Solution, []},
    {Schema.Stakeholder, []},
    {Schema.Event, []},
    {Schema.ProblemUser, []},
    {Schema.UserProfile, []},
    {Schema.ProblemInvite, []},
    {Schema.ProblemSector, []},
    {Schema.Page, [embed: [:body]]},
    {Schema.ComingSoon, []},
    {Schema.Tag, []},
    {Schema.PushSub, []},
    {Scrivener.Page, []},
    {ProblemService.Services.FeedService.ProblemFeedItem, []},
    {Schema.User, [:password, :clear_password, :salt]}
  ]

  def modules, do:  @modules
end


Enum.map(Modules.modules, fn {module, strip} ->
  defimpl Jason.Encoder, for: module do
    def encode(schema, options) do
     Util.MapUtil.from_struct(schema, unquote(Modules.modules))
      |>  Jason.Encoder.Map.encode(options)
    end
  end
end)
