defmodule ProblemService.SchemaRepo do
  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)

    quote do
      alias ProblemService.Repo
      import Ecto.Query
      alias ProblemService
      alias unquote(schema)

      @this unquote(schema)

      def delete!(item) do
        Repo.delete!(item)
      end

      def delete_all(q) do
        Repo.delete_all(q)
      end

      def update!(item) do
        Repo.update!(item)
      end

      def update!(item, params) do
        @this.changeset(item, params) |> Repo.update!()
      end

      def update(item, params) do
        @this.changeset(item, params) |> Repo.update()
      end

      def insert!(params) do
        Repo.insert!(@this.changeset(%@this{}, params))
      end

      def insert(params) do
        Repo.insert(@this.changeset(%@this{}, params))
      end


      def get(id, params) when is_map(params) do
        IO.inspect(extract_preloads(params))
        get(id, extract_preloads(params))
      end

      def get(id, preloads \\ []) do
        Repo.get(@this, id) |> Repo.preload(preloads)
      end


      def one(q \\ @this, preloads \\ []) do
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

      def paginate(q \\ @this, params \\ %{}, preloads \\ []) do
        query = from q in q, preload: ^preloads
        Repo.paginate(query, params)
      end

      def with_order_latest(), do: with_order_latest(@this)

      def with_order_latest(q) do
        from q in q,
          order_by: {:desc, q.inserted_at}
      end

      defp prl(q, preloads) do
        case preloads do
          [] -> q
          preloads -> Repo.preload(q, preloads)
        end
      end

      defp extract_preloads(params) do
        preloads = case Map.get(params, "preloads", []) do
          p when is_list(p) -> p
          p -> String.split(p, ",")
        end
        |> Enum.map(fn preload ->
          # String to existing atom if exists
          case String.to_existing_atom(preload) do
            atom when is_atom(atom) -> atom
            _ -> String.to_atom(preload)
          end
        end)
      end

      defoverridable insert: 1
    end
  end
end
