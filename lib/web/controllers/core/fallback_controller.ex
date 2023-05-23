defmodule ProblemService.FallbackController do
  use ProblemService.Web, :controller



  def render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
  end

  def render_detail(message) do
    message
  end

  def call(conn, {:error, %Ecto.Changeset{errors: errors}}) do
    IO.inspect("HERE I AM ")

    response =
      Enum.map(errors, fn {field, detail} ->
        "#{field}: #{render_detail(detail)} "
      end)

    conn
    |> put_status(500)
    |> json(%{error: response})
  end

  def call(conn, error) do
    IO.inspect("Unknown error")
    IO.inspect(error)

    conn
    |> put_status(500)
    |> json(%{error: :unknown})
  end



  def call(conn, {:error, error}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: error})
  end

  def call(conn, {:unauthorized, error}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: error})
  end


end
