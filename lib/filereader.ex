defmodule Filereader do
  defstruct shininess: 0.0, attenuation: Graphmath.Vec3.create(1.0, 0.0, 0.0)

  def read(filename) do
    {:ok, scene_pid} = GenServer.start_link(Scene, %Scene{})
    {:ok, vertex_buffer_pid} = GenServer.start_link(VertexBuffer, [])

    stream = File.stream!(filename)
    _transformation_stack = [Graphmath.Mat44.identity()]
    for command <- stream do
      command = String.split(command)
      command_name = Enum.at(command, 0)
      cond do
        command_name == "size" -> { Enum.at(command, 1), Enum.at(command, 2) }
        command_name == "vertex" -> VertexBuffer.add(
          vertex_buffer_pid, Graphmath.Vec3.create(
            elem(Float.parse(Enum.at(command, 1)), 0),
            elem(Float.parse(Enum.at(command, 2)), 0),
            elem(Float.parse(Enum.at(command, 3)), 0)
          )
        )
        command_name == "tri" -> Scene.add_triangle(
          scene_pid, Primitives.Triangle.from(
            VertexBuffer.get_vertex_at(vertex_buffer_pid, String.to_integer(Enum.at(command, 1))),
            VertexBuffer.get_vertex_at(vertex_buffer_pid, String.to_integer(Enum.at(command, 2))),
            VertexBuffer.get_vertex_at(vertex_buffer_pid, String.to_integer(Enum.at(command, 3)))
          )
        )
        true -> "Command not understood"
      end
    end
  end
end
