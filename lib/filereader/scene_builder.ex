defmodule SceneBuilder do
  use GenServer
  defstruct width: 640, height: 480, camera: 6000, filename: "default.png", maxdepth: 1, triangles: [], spheres: [], transformation_stack: [Graphmath.Mat44.identity()], materials: Materials.from()

  def init(scene) do
    {:ok, scene}
  end

  def add_triangle(pid, triangle) do
    GenServer.call(pid, {:add_triangle, triangle})
  end

  def add_sphere(pid, sphere) do
    GenServer.call(pid, {:add_sphere, sphere})
  end

  def set_resolution(pid, width, height) do
    GenServer.call(pid, {:set_resolution, width, height})
  end

  def set_output(pid, output) do
    GenServer.call(pid, {:set_output, output})
  end

  def set_material(pid, color, material) do
    GenServer.call(pid, {:set_material, material, color})
  end

  def apply_transform(pid, transform) do
    GenServer.call(pid, {:apply_transform, transform})
  end

  def push_transform(pid) do
    GenServer.call(pid, {:push_transform})
  end

  def pop_transform(pid) do
    GenServer.call(pid, {:pop_transform})
  end

  def handle_call({:add_triangle, triangle}, _from, state) do
    new_triangles = state.triangles ++ [triangle]
    {:reply, state, %{state | triangles: new_triangles}}
  end

  def handle_call({:add_sphere, sphere}, _from, state) do
    new_spheres = state.spheres ++ [sphere]
    {:reply, state, %{state | spheres: new_spheres}}
  end

  def handle_call({:set_resolution, width, height}, _from, state) do
    {:reply, state, %{state | width: width, height: height}}
  end

  def handle_call({:set_material, material, color}, _from, state) do
    new_materials = Map.replace(state.materials, material, color)
    {:reply, state, %{state | materials: new_materials}}
  end

  def handle_call({:set_output, output}, _from, state) do
    {:reply, state, %{state | filename: output}}
  end

  def handle_call({:push_transform}, _from, state) do
    new_stack = [hd(state.transformation_stack)] ++ state.transformation_stack
    {:reply, state, %{state | transformation_stack: new_stack}}
  end

  def handle_call({:pop_transform}, _from, state) do
    {:reply, state, %{state | transformation_stack: tl(state.transformation_stack)}}
  end

  def handle_call({:apply_transform, transform}, _from, state) do
    tail = tl(state.transformation_stack)
    new_stack = [Graphmath.Mat44.multiply(hd(state.transformation_stack), transform)] ++ tail
    {:reply, state, %{state | transformation_stack: new_stack}}
  end
end
