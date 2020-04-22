defmodule Vocial.ChatCache do
  use GenServer

  @table :presence
  @key :statuses

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def write(topic, username, status) do
    row = %{
      topic: topic,
      username: username,
      status: status,
      timestamp: DateTime.utc_now()
    }

    GenServer.cast(__MODULE__, {:write, row})
  end

  def lookup() do
    GenServer.call(__MODULE__, :lookup)
  end

  def init(_) do
    table = :ets.new(@table, [:bag])
    {:ok, table}
  end

  def handle_cast({:write, row}, table) do
    :ets.insert(table, {@key, row})
    {:noreply, table}
  end

  def handle_call(:lookup, _, table) do
    case :ets.lookup(table, @key) do
      [] ->
        {:reply, [], table}

      data ->
        results = Enum.map(data, fn {_k, v} -> v end)
        {:reply, results, table}
    end
  end
end
