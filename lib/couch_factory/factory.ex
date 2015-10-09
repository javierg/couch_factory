defmodule CouchFactory.Factory do
  defmacro __using__(_opts) do
    quote do
      alias CouchFactory.Db, as: Db
      import CouchFactory.Factory
      @before_compile CouchFactory.Factory

      def save(doc), do: Db.save(doc)
    end
  end

  defmacro factory(name, map) do
    quote do
      def unquote(name)(), do: unquote(map)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def build(name, opts \\ []) do
        apply(__MODULE__, name, [])
        |> Dict.merge(opts)
        |> CouchFactory.Worker.build
      end

      def create(name, opts \\ []) do
        apply(__MODULE__, name, [])
        |> Dict.merge(opts)
        |> CouchFactory.Worker.create
      end

      def properties_for(name, opts \\ []) do
        apply(__MODULE__, name, [])
        |> Dict.merge(opts)
        |> CouchFactory.Worker.build_properties
      end
    end
  end
end
