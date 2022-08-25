defmodule EventService.SchemaRepo do
  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)

    quote do
      alias EventService.Repo
      import Ecto.Query
      alias EventService
      alias unquote(schema)

      @this unquote(schema)

      def create(params) do
        Repo.insert!(@this.changeset(%@this{}, params))
      end

      def insert(params) do
        Repo.insert(@this.changeset(%@this{}, params))
      end

      def get(id, preloads \\ []) do
        Repo.get(@this, id)  |> Repo.preload(preloads)
      end

      def get_by(term, preloads \\ []) do
        Repo.get_by(@this, term)  |> Repo.preload(preloads)
      end

      def all(q \\ @this, params \\ %{}, preloads \\ []) do
        Repo.all(q)
        |> Repo.preload(preloads)
        # |> Repo.paginate(params)
      end

      defoverridable insert: 1

    end
  end
end
