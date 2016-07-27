defmodule CouchFactory.Counter do
  def start name do
    {existing, process_name} = whereis(name)

    if existing do
      {:ok, existing}
    else
      Agent.start_link(fn -> 0 end, name: process_name)
    end
  end

  def whereis name do
    process_name = to_string(name) <> "_couch_factory"
                   |> String.to_atom

    {Process.whereis(process_name), process_name}
  end

  def increment(name) do
    start(name) |> click
  end

  def click({:ok, pid}), do: click(pid)

  def click(pid) do
    Agent.get_and_update(pid, fn(n) -> {n + 1, n + 1} end)
  end

  def set(pid, value) do
    Agent.update(pid, fn(_) -> value end)
  end

  def get(pid) do
    Agent.get(pid, fn(n) -> n end)
  end

  def reset(pid) do
    Agent.set(pid, 0)
  end
end
