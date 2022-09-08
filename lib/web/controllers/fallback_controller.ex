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

end
