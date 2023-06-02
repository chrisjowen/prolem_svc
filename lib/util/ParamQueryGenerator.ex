defmodule Util.ParamQueryGenerator do
  import Ecto.Query
  alias Util.AtomUtil

  def generate(queriable, query) do
    query
    |> String.split("|")
    |> Enum.reduce(queriable, fn q, queriable ->
      queriable |> parse_query(q)
    end)
  end


  # TODO: Better parser

  defp parse_query(queriable, ""), do: queriable


  defp parse_query(queriable, q) do
    case String.split(q, "=") do
      ops when length(ops) == 2 ->
        [a, b] = ops
        a = AtomUtil.string_to_atom(a)
        queriable |> where([q], field(q, ^a) == ^b)

      _ ->
        queriable
    end
  end




end
