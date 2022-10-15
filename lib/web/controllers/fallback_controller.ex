defmodule Totem.FallbackController do
  use TotemWeb, :controller

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

  def call(conn, %Ecto.Changeset{errors: errors}) do
    IO.inspect("Ecto error")
    IO.inspect(errors)

    conn
    |> put_status(500)
    |> json(%{error: :ecto})
  end


  def call(conn, error) do
    IO.inspect("Unknown error")
    IO.inspect(error)

    conn
    |> put_status(500)
    |> json(%{error: :unknown})
  end


end
