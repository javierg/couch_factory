defmodule CouchFactory.Factory do
  @docmodule """
  Factory Girl like generator with doc persistence in database for ExUnit testing.

  Couch Factory have a dependency on Couchbeam.

  This module have the macros to be used in a factory definition.

  ##Example

      defmodule MyFactory do
        use CouchFactory.Factory

        factory :doc_name,
          property_a: "value_a",
          property_b: "value_b",
          prperty_c: "value_c"

        factory :other_doc,
          property: "a value",
          other_property: [1,2,3]

  Once the file is loaded included for compilation in the `test_helper` file.
  You can call this functions:

      MyFactory.build(:other_doc)
      MyFactory.create(:doc_name)

  It will also create a function with the name of the factory, that returns a
  dictionary:

    MaFactory.doc_name() # => [property_a: "value_a", property_b: "value_b", property_c: "value_c"]
  """

  defmacro __using__(_opts) do
    quote do
      alias CouchFactory.Db, as: Db
      import CouchFactory.Factory
      @before_compile CouchFactory.Factory

      @doc """
        Implements :couchbeam.save_doc/2 function but accepts a single argument,
        which is a list of tupples `{[{"key", "value"}]}`, as cuchbeam format documents.
      """
      def save(doc), do: Db.save(doc)
    end
  end

  @doc """
  This will generate a function per named factory.
  """
  defmacro factory(name, map) do
    quote do
      @doc false
      def unquote(name)(), do: unquote(map)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      @doc """
        Build will return a none persisted tuple list as required by Couchbeam
        to create a record. It expects the factory name and optionally the properties to be overriten.

        ##Example

        In MyFactory.exs

            factory :user,
              name: "A name",
              password: "Abc123"

            MyFactory.build(:user, [name: "new name"]

        Will return

            {[{"name", "new name"}, {"password", "Abc123"}]}
      """
      def build(name, opts \\ []) do
        case apply_and_merge(name, opts) do
          :missing -> {:error, :missing_factory}
          doc -> CouchFactory.Worker.build(doc)
        end
      end

      @doc """
      Creates and persist a document in couchdb through :couchbeam.save_doc/2

      It expects a factory name, and an optional dict of options.

      ##Example

      In MyFactory.exs

          factory :user,
            name: "A name",
            password: "Abc123"

          MyFactory.create(:user, [name: "new name"]

      Will return on success something like

          {:ok, {[{"_id", "ef12ea4"}, {"_rev", "1-ea456ee8"}, {"name", "new name"}, {"password", "Abc123"}]}}

      On error will return

          {:error, error}

      Where `error` is what :couchbeam.save_doc/2 returns, for example if is a `409` response from the couch server

          error == :conflict
      """
      def create(name, opts \\ []) do
        case apply_and_merge(name, opts) do
          :missing -> {:error, :missing_factory}
          doc -> CouchFactory.Worker.create(doc)
        end
      end

      @doc """
        Properties for is similar to the build/2,
        but it returns a map of properties.

        ##Example

        In MyFactory.exs

            factory :user,
              name: "A name",
              password: "Abc123"

            MyFactory.build(:user, [name: "new name"]

        Will return

            %{name: "new name", password: "Abc123"}
      """
      def properties_for(name, opts \\ []) do
        case apply_and_merge(name, opts) do
          :missing -> {:error, :missing_factory}
          doc -> CouchFactory.Worker.build_properties(doc)
        end
      end

      @doc false
      defp apply_and_merge(name, opts) do
        if function_exported?(__MODULE__, name, 0) do
          apply(__MODULE__, name, [])
          |> Dict.merge(opts)
        else
          :missing
        end
      end
    end
  end
end
