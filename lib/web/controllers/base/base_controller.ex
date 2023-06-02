defmodule ProblemService.BaseController do
  defmacro __using__(ops \\ []) do
    quote do
      use ProblemService.Web, :controller
      action_fallback ProblemService.FallbackController
      alias ProblemService.Repo
      import Guardian.Plug
      import ProblemService.BaseController

      @ops unquote(ops)

      if(Keyword.has_key?(@ops, :schema)) do
        defcrud(Keyword.get(@ops, :schema), Keyword.get(@ops, :only, [:show, :index, :create, :update, :delete]))
      end

      defp extract_preloads(params) do
        Map.get(params, "preloads", "")
        |> String.split(",")
        |> Enum.filter(&(&1 != ""))
        |> Enum.map(&string_to_atom/1)
      end

      def string_to_atom(str) do
        try do
          String.to_existing_atom(str)
        rescue
          ArgumentError -> String.to_atom(str)
        end
      end
    end
  end

  defmacro defcrud(schema, routes \\ [:show, :index, :create, :update, :delete]) do
    quote do
      alias ProblemService.Repo
      import Ecto.Query

      if(Enum.member?(unquote(routes), :show)) do
        def show(conn, %{"id" => id} = params) do
          result = Repo.get(unquote(schema), id) |> Repo.preload(extract_preloads(params))
          json(conn, result)
        end
      end

      if(Enum.member?(unquote(routes), :index)) do
        def index(conn, params) do
          preloads = extract_preloads(params) |> IO.inspect()
          query = Map.get(params, "query", "")

          result =
            from(q in unquote(schema),
              preload: ^preloads
            )
            |> Util.ParamQueryGenerator.generate(query)
            |> Repo.paginate(params)

          json(conn, result)
        end
      end

      if(Enum.member?(unquote(routes), :create)) do
        def create(conn, params) do
          with {:ok, entity} <- Repo.insert(unquote(schema), params) do
            json(conn, entity)
          end
        end
      end

      if(Enum.member?(unquote(routes), :update)) do
        def update(conn, %{"id" => id} = params) do
          entity = Repo.get(unquote(schema), id)

          with {:ok, updated} <-
                 entity
                 |> unquote(schema).changeset(params)
                 |> Repo.update() do
            json(conn, updated)
          end
        end
      end

      if(Enum.member?(unquote(routes), :delete)) do
        def delete(conn, %{"id" => id}) do
          item = Repo.get(unquote(schema), id)
          Repo.delete!(item)
          json(conn, %{ok: id})
        end
      end
    end
  end
end
