defmodule Directional do
  defstruct direction: Graphmath.Vec3.create(), colorvec: Color.create(), attenuation: Graphmath.Vec3.create(1.0, 0.0, 0.0), position: Graphmath.Vec3.create()

  def from(direction, colorvec, attenuation, position) do
    %Directional{direction: direction, colorvec: colorvec, attenuation: attenuation, position: position}
  end
end
