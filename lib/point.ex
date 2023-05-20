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

  def compute_direction(point, origin) do
    Graphmath.Vec3.normalize(Graphmath.Vec3.subtract(point.direction, origin))
  end

  def compute_attenuation(point, hitpoint) do
    distance_to_light = compute_distance(point, hitpoint)
    { attenuation_x, attenuation_y, attenuation_z } = point.attenuation
    1.0/(attenuation_x + attenuation_y * distance_to_light + attenuation_z*(distance_to_light*distance_to_light))
  end

  defp compute_distance(point, hitpoint) do
    Graphmath.Vec3.length(Graphmath.Vec3.subtract(point.position, hitpoint))
  end
end
