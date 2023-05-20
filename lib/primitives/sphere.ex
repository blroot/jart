defmodule Primitives.Sphere do
  defstruct center: Graphmath.Vec3.create(), radius: 0.0, transform: Graphmath.Mat44.identity(), inverse_transform: Graphmath.Mat44.inverse(Graphmath.Mat44.identity()), materials: Materials.from()

  def from(center, radius, transform, materials \\ Materials.from()) do
    %Primitives.Sphere{
      center: center,
      radius: radius,
      transform: transform,
      inverse_transform: Graphmath.Mat44.inverse(transform),
      materials: materials
    }
  end

  def from() do
    %Primitives.Sphere{}
  end

  def intersect(sphere, ray) do
    { direction_x, direction_y, direction_z } = ray.direction
    { origin_x, origin_y, origin_z } = ray.eye

    { direction_x, direction_y, direction_z, _ } = Graphmath.Mat44.apply_left({direction_x, direction_y, direction_z, 0.0}, sphere.inverse_transform)
    ray_direction = Graphmath.Vec3.normalize(Graphmath.Vec3.create(direction_x, direction_y, direction_z))

    { origin_x, origin_y, origin_z, _ } = Graphmath.Mat44.apply_left({origin_x, origin_y, origin_z, 1.0}, sphere.inverse_transform)
    ray_origin = Graphmath.Vec3.create(origin_x, origin_y, origin_z)

    ray_origin_center = Graphmath.Vec3.subtract(ray_origin, sphere.center)

    a = Graphmath.Vec3.dot(ray_direction, ray_direction)
    b = 2*(Graphmath.Vec3.dot(ray_direction, ray_origin_center))
    c = Graphmath.Vec3.dot(ray_origin_center, ray_origin_center) - sphere.radius*sphere.radius
    discriminant = b*b - 4*a*c

    cond do
      discriminant >= 0.0 -> compute_roots(a, b, discriminant, ray_origin, ray_direction, ray.eye, sphere)
      true -> %{intersection: 0.0, point: Graphmath.Vec3.create(), normal: Graphmath.Vec3.create()}
    end
  end

  defp compute_roots(a, b, discriminant, ray_origin, ray_direction, ray_eye, sphere) do
    first_root = (-b + :math.sqrt(discriminant))/2*a
    second_root = (-b - :math.sqrt(discriminant))/2*a

    intersection = cond do
      first_root > 0.0 and second_root > 0.0 and first_root > second_root -> second_root
      first_root > 0.0 and second_root > 0.0 and first_root < second_root -> first_root
      first_root < 0.0 and second_root > 0.0 -> second_root
      first_root > 0.0 and second_root < 0.0 -> first_root
      true -> 0.0
    end

    { point_x, point_y, point_z } = Graphmath.Vec3.add(ray_origin, Graphmath.Vec3.scale(ray_direction, intersection))
    { point_x, point_y, point_z, _ } = Graphmath.Mat44.apply_left({point_x, point_y, point_z, 1.0}, sphere.transform)
    intersection = Graphmath.Vec3.subtract(Graphmath.Vec3.create(point_x, point_y, point_z), ray_eye)
    intersection = Graphmath.Vec3.length(intersection)

    { normal_x, normal_y, normal_z, _ } = Graphmath.Mat44.apply_left({point_x, point_y, point_z, 1.0}, sphere.inverse_transform)
    { normal_x, normal_y, normal_z } = Graphmath.Vec3.subtract(Graphmath.Vec3.create(normal_x, normal_y, normal_z), sphere.center)
    { normal_x, normal_y, normal_z, _ } = Graphmath.Mat44.apply_left_transpose({normal_x, normal_y, normal_z, 0.0}, sphere.inverse_transform)
    normal = Graphmath.Vec3.normalize(Graphmath.Vec3.create(normal_x, normal_y, normal_z))

    %{intersection: intersection, point: Graphmath.Vec3.create(point_x, point_y, point_z), normal: normal}
  end
end
