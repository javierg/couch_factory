defmodule CouchFactory.Worker do
  use GenServer
  alias CouchFactory.Db, as: Db

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, [name: :couch_factory])
  end

  def build(doc) do
    GenServer.call(:couch_factory, {:build, doc})
  end

  def create(doc) do
    GenServer.call(:couch_factory, {:create, doc})
  end

  ## Server callbacks
  def init(:ok), do: {:ok, {}}

  def handle_call({:build, doc}, _from, {}) do
    doc = Db.list_to_ejson(doc)
    {:reply, doc, {}}
  end

  def handle_call({:create, doc}, _from, {}) do
    case Db.save(doc) do
      {:error, error} -> {:reply, {:error, error}, {}}
      {:ok, doc}      -> {:reply, Db.reload(doc), {}}
    end
  end
end
