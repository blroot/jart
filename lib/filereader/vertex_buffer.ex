defmodule VertexBuffer do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def add(pid, element) do
    GenServer.call(pid, {:add, element})
  end

  def get_vertex_at(pid, index) do
    GenServer.call(pid, {:get_vertex_at, index})
  end

  def handle_call({:add, element}, _from, state) do
    {:reply, element, state ++ [element]}
  end

  def handle_call({:get_vertex_at, index}, _from, state) do
    {:reply, Enum.at(state, index), state}
  end
end
