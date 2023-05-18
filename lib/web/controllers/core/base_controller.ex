defmodule ProblemService.BaseController do
  defmacro __using__(_ops) do
    quote do
      use ProblemService.Web, :controller
      action_fallback ProblemService.FallbackController
      alias ProblemService.Repo
      import Guardian.Plug




    end
  end
end
