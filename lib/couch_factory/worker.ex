defmodule CouchFactory.Worker do
  use GenServer
  alias CouchFactory.Db, as: Db

  @doc false
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, [name: :couch_factory])
  end

  @doc false
  def build(doc) do
    GenServer.call(:couch_factory, {:build, doc})
  end

  @doc false
  def create(doc) do
    GenServer.call(:couch_factory, {:create, doc})
  end

  @doc false
  def build_properties(doc) do
    GenServer.call(:couch_factory, {:doc_to_map, doc})
  end

  @doc false
  def init(:ok), do: {:ok, {}}

  @doc false
  def handle_call({:build, doc}, _from, {}) do
    doc = Db.list_to_ejson(doc)
    {:reply, doc, {}}
  end

  @doc false
  def handle_call({:create, doc}, _from, {}) do
    case Db.save(doc) do
      {:error, error} -> {:reply, {:error, error}, {}}
      {:ok, doc}      -> {:reply, Db.reload(doc), {}}
    end
  end

  @doc false
  def handle_call({:doc_to_map, doc}, _from, {}) do
    {:reply, List.foldl(doc, %{}, &map_doc/2), {}}
  end

  @doc false
  defp map_doc({key, value}, acc) do
    Map.put(acc, key, value)
  end
end
