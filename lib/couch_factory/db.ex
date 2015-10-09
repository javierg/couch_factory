defmodule CouchFactory.Db do
  alias :couchbeam, as: Conn
  alias :couchbeam_doc, as: Doc

  @moduledoc """
  Set of helper functions to interact with Couchbeam.

  The configration is set on `config/config.exs` and expected like:

      config :couch_factory, CouchFactory.Db,
        host: "http://localhost:5984",
        db: "db_name",
        user: "username",
        password: "Apa$$w0rd"

  CouchFactory will assume you have created the db and that couchdb is running.

  Because Couchbeam doesn't have a Hex package, it needs to be added as a git dependency to your project.

  This module just implement the required functions for factory management, and are not to meant to be used directly by your app.
  """

  def reload(doc), do: value(doc, "_id") |> get
  def get(doc_id), do: Conn.open_doc(db, doc_id)
  def value(doc, key), do: Doc.get_value(key, doc)

  def save(doc) do
    json_doc = list_to_ejson(doc)
    Conn.save_doc(db, json_doc)
  end

  def destroy(doc) do
    json_doc = list_to_ejson(doc)
    Conn.delete_doc(db, json_doc)
  end

  def list_to_ejson(list) do
    list
    |> :couchbeam_ejson.encode
    |> :couchbeam_ejson.decode
  end

  def reset!() do
    Conn.delete_db(db)
    Conn.create_db(server, config[:db])
  end

  defp authorization? do
    config[:user] != nil &&
    String.length(config[:user]) > 0
  end

  defp server do
    opts = if authorization?, do: [{:basic_auth, {config[:user], config[:password]}}], else: []
    Conn.server_connection(config[:host], opts)
  end

  defp db do
    {:ok, open_db} = Conn.open_db(server, config[:db], [])
    open_db
  end

  defp config do
    Application.get_env(:couch_factory, CouchFactory.Db)
  end

end
