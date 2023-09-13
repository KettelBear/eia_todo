defmodule Todo.Server do
  @moduledoc false

  use GenServer

  #####################
  #    Client Code    #
  #####################

  def start() do
    GenServer.start(__MODULE__, TodoList.new(), name: __MODULE__)
  end

  def add_entry(new_entry) do
    GenServer.cast(__MODULE__, {:add_entry, new_entry})
  end

  def entries(date) do
    GenServer.call(__MODULE__, {:entries, date})
  end

  #####################
  #    Server Code    #
  #####################

  @impl GenServer
  def init(_), do: {:ok, TodoList.new()}

  @impl GenServer
  def handle_cast({:add_entry, entry}, state) do
    {:noreply, TodoList.create(state, entry)}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, state) do
    {:reply, TodoList.read(state, date), state}
  end
end
