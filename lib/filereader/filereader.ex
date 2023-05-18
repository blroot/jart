defmodule Filereader do
  defstruct shininess: 0.0, attenuation: Graphmath.Vec3.create(1.0, 0.0, 0.0)

  def read(stream) do
    {:ok, scene_builder_pid} = GenServer.start_link(SceneBuilder, %SceneBuilder{})
    {:ok, vertex_buffer_pid} = GenServer.start_link(VertexBuffer, [])

    for command <- stream do
      command = String.split(command)
      command_name = Enum.at(command, 0)
      cond do
        command_name == "size" -> parse_resolution(scene_builder_pid, command)
        command_name == "vertex" -> parse_vertex(vertex_buffer_pid, command)
        command_name == "tri" -> parse_triangle(vertex_buffer_pid, scene_builder_pid, command)
        command_name == "output" -> parse_output(scene_builder_pid, command)
        command_name == "translate" -> parse_translate(scene_builder_pid, command)
        command_name == "scale" -> parse_scale(scene_builder_pid, command)
        command_name == "rotate" -> parse_rotate(scene_builder_pid, command)
        command_name == "pushTransform" -> SceneBuilder.push_transform(scene_builder_pid)
        command_name == "popTransform" -> SceneBuilder.pop_transform(scene_builder_pid)
        true -> "Command not understood"
      end
    end
    :sys.get_state(scene_builder_pid)
  end

  defp parse_rotate(scene_builder_pid, command) do
    rad = (:math.pi()/180) * String.to_integer(Enum.at(command, 4))
    x_axis = String.to_integer(Enum.at(command, 1))
    y_axis = String.to_integer(Enum.at(command, 2))
    z_axis = String.to_integer(Enum.at(command, 3))

    x = Graphmath.Mat44.make_rotate_x(rad)
    y = Graphmath.Mat44.make_rotate_y(rad)
    z = Graphmath.Mat44.make_rotate_z(rad)

    transform = case { x_axis, y_axis, z_axis } do
      { 0, 0, 0 } -> Graphmath.Mat44.identity()
      { 0, 0, 1 } -> z
      { 0, 1, 0 } -> y
      { 0, 1, 1 } -> Graphmath.Mat44.multiply(y, z)
      { 1, 0, 0 } -> x
      { 1, 0, 1 } -> Graphmath.Mat44.multiply(x, z)
      { 1, 1, 0 } -> Graphmath.Mat44.multiply(x, y)
      { 1, 1, 1 } -> Graphmath.Mat44.multiply(Graphmath.Mat44.multiply(x, y), z)
    end
    SceneBuilder.apply_transform(scene_builder_pid, transform)
  end

  defp parse_scale(scene_builder_pid, command) do
    scale_matrix = Graphmath.Mat44.make_scale(
      elem(Float.parse(Enum.at(command, 1)), 0),
      elem(Float.parse(Enum.at(command, 2)), 0),
      elem(Float.parse(Enum.at(command, 3)), 0),
      1.0
    )
    SceneBuilder.apply_transform(scene_builder_pid, scale_matrix)
  end

  defp parse_translate(scene_builder_pid, command) do
    translation_matrix = Graphmath.Mat44.make_translate(
      elem(Float.parse(Enum.at(command, 1)), 0),
      elem(Float.parse(Enum.at(command, 2)), 0),
      elem(Float.parse(Enum.at(command, 3)), 0)
    )
    SceneBuilder.apply_transform(scene_builder_pid, translation_matrix)
  end

  defp parse_output(scene_builder_pid, command) do
    SceneBuilder.set_output(scene_builder_pid, Enum.at(command, 1))
  end

  defp parse_resolution(scene_pid, command) do
    SceneBuilder.set_resolution(scene_pid, String.to_integer(Enum.at(command, 1)), String.to_integer(Enum.at(command, 2)))
  end

  defp parse_vertex(vertex_buffer_pid, command) do
    VertexBuffer.add(
      vertex_buffer_pid, Graphmath.Vec3.create(
        elem(Float.parse(Enum.at(command, 1)), 0),
        elem(Float.parse(Enum.at(command, 2)), 0),
        elem(Float.parse(Enum.at(command, 3)), 0)
      )
    )
  end

  defp parse_triangle(vertex_buffer_pid, scene_pid, command) do
    SceneBuilder.add_triangle(
      scene_pid, Primitives.Triangle.from(
        VertexBuffer.get_vertex_at(vertex_buffer_pid, String.to_integer(Enum.at(command, 1))),
        VertexBuffer.get_vertex_at(vertex_buffer_pid, String.to_integer(Enum.at(command, 2))),
        VertexBuffer.get_vertex_at(vertex_buffer_pid, String.to_integer(Enum.at(command, 3)))
      )
    )
  end
end
