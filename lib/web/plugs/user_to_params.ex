defmodule ProblemService.Plug.UserToParams do
  import Guardian.Plug
  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    case current_resource(conn) do
      nil ->
        conn
      user ->
        %{conn | params:  Map.put(conn.params, "user_id", user.id)}
    end
  end


end
