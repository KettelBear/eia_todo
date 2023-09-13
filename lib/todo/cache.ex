defmodule Todo.Cache do
  alias Todo.Server, as: TServer

  use GenServer

  #####################
  #    Client Code    #
  #####################

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(pid, list_name) do
    GenServer.call(pid, {:server_process, list_name})
  end

  #####################
  #    Server Code    #
  #####################

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, list_name}, _, servers) do
    case Map.fetch(servers, list_name) do
      {:ok, server} ->
        {:reply, server, servers}

      :error ->
        {:ok, new_server} = TServer.start()
        {:reply, new_server, Map.put(servers, list_name, new_server)}
    end
  end
end
