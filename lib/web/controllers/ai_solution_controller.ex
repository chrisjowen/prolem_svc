defmodule ProblemService.AiSolutionController do
  use ProblemService.BaseController

  def modules, do: %{
    "overview" => %{
      "module" => Openai.SolutionOverview
    },
    "features" => %{
      "module" => Openai.SuggestSolutionFeatures
    }
  }

  def advice(conn, params) do
    case Map.get(modules(), params["type"]) do
      nil -> json(conn, %{error: "Invalid Solution Adviser cannot advise on type"})
      handler ->
        module = handler["module"]
        arg_mapper  = Map.get(handler, "arg_mapper", fn _conn, params -> [params] end )
        args = arg_mapper.(conn, params)
        #IO.inspect(module)
        #IO.inspect(args)
        with {:ok, result} <- apply(module, :process, args) do
          json(conn, result)
        end
    end
  end
end
