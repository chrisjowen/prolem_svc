defmodule Totem.BaseController do
  defmacro __using__(_ops) do
    quote do
      use TotemWeb, :controller
      action_fallback Totem.FallbackController
      alias Totem.Repo
      import Guardian.Plug

    end
  end
end
