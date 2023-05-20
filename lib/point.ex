defmodule Point do
  defstruct position: Graphmath.Vec3.create(), colorvec: Color.create(), direction: Graphmath.Vec3.create(), attenuation: Graphmath.Vec3.create(1.0, 0.0, 0.0)

  def from(position, colorvec, direction, attenuation) do
    %Point{position: position, colorvec: colorvec, direction: direction, attenuation: attenuation}
  end

  def apply_transform(point, transform) do
    { pos_x, pos_y, pos_z } = point.position
    { pos_x, pos_y, pos_z, _ } = Graphmath.Mat44.apply_left({ pos_x, pos_y, pos_z, 1.0}, transform)

    %Point{point | position: Graphmath.Vec3.create(pos_x, pos_y, pos_z)}
  end
end
