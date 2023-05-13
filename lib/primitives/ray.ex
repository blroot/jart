defmodule Primitives.Ray do
  defstruct eye: Graphmath.Vec3.create(), direction: Graphmath.Vec3.create()

  def from({x, y, z}, {a, b, c}) do
    %Primitives.Ray{eye: {x, y, z}, direction: {a, b, c}}
  end

  def from() do
    %Primitives.Ray{}
  end
end
