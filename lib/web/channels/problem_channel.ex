defmodule ProblemService.ProblemChannel do
  use Phoenix.Channel
  # alias Phoenix.Socket.Broadcast

  def join("problem:" <> _, _params, socket) do
    {:ok, socket
        |> assign(:topics, [])
      }
  end


end
