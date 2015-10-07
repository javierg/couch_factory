defmodule CouchFactory.Db do
  alias :couchbeam, as: Conn
  alias :couchbeam_doc, as: Doc

  def reload(doc), do: value(doc, "_id") |> get
  def get(doc_id), do: Conn.open_doc(db, doc_id)
  def value(doc, key), do: Doc.get_value(key, doc)

  def save(doc) do
    json_doc = list_to_ejson(doc)
    Conn.save_doc(db, json_doc)
  end

  def list_to_ejson(list) do
    list
    |> :couchbeam_ejson.encode
    |> :couchbeam_ejson.decode
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

  #TODO: how can I redefine this in the consumer app?
  defp config do
    Application.get_env(:couch_factory, CouchFactory.Db)
  end

end
