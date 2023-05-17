defmodule Scene do
  use GenServer
  defstruct width: 640, height: 480, camera: 6000, filename: "default.png", maxdepth: 1, triangles: [], spheres: []

  def init(scene) do
    {:ok, scene}
  end

  def add_triangle(pid, triangle) do
    GenServer.call(pid, {:add_triangle, triangle})
  end

  def handle_call({:add_triangle, triangle}, _from, state) do
    new_triangles = state.triangles ++ [triangle]
    {:reply, state, %{state | triangles: new_triangles}}
  end

end
