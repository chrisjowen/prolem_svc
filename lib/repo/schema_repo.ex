defmodule Totem.SchemaRepo do
  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)

    quote do
      alias Totem.Repo
      import Ecto.Query
      alias Totem
      alias unquote(schema)

      @this unquote(schema)


      def update!(item) do
        Repo.update!(item)
      end

      def insert!(params) do
        Repo.insert!(@this.changeset(%@this{}, params))
      end

      def insert(params) do
        Repo.insert(@this.changeset(%@this{}, params))
      end

      def get(id, preloads \\ []) do
        Repo.get(@this, id) |> Repo.preload(preloads)
      end

      def one(q, preloads \\ []) do
        case Repo.one(q) do
          nil -> {:error, :not_found}
          item -> {:ok, item |> prl(preloads)}
        end
      end

      def get_by(term, preloads \\ []) do
        Repo.get_by(@this, term) |> Repo.preload(preloads)
      end

      def all(q \\ @this, params \\ %{}, preloads \\ []) do
        Repo.all(q)
        |> Repo.preload(preloads)
      end

      def with_order_latest(), do: with_order_latest(@this)
      def with_order_latest(q) do
        from q in q,
          order_by: {:desc, q.updated_at}
      end

      defp prl(q, preloads) do
        case preloads do
          [] -> q
          preloads -> Repo.preload(q, preloads)
        end
      end

      defoverridable insert: 1
    end
  end
end
