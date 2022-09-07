defmodule Totem.BaseController do
  defmacro __using__(_ops) do
    quote do
      use TotemWeb, :controller
      alias Totem.Repo
      import Guardian.Plug

    end
  end
end
