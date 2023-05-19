defmodule Primitives.Triangle do
  defstruct a: Graphmath.Vec3.create(), b: Graphmath.Vec3.create(), c: Graphmath.Vec3.create(), normal: Graphmath.Vec3.create(), materials: Materials.from()

  def from(a, b, c, materials \\ Materials.from()) do
    b_minus_a = Graphmath.Vec3.subtract(b, a)
    c_minus_a = Graphmath.Vec3.subtract(c, a)
    normal = Graphmath.Vec3.normalize(Graphmath.Vec3.cross(b_minus_a, c_minus_a))
    %Primitives.Triangle{a: a, b: b, c: c, normal: normal, materials: materials }
  end

  @spec intersect(
          atom
          | %{
              :a => {float, float, float},
              :b => {float, float, float},
              :c => {float, float, float},
              :normal => {float, float, float},
              optional(any) => any
            },
          atom
          | %{
              :direction => {float, float, float},
              :eye => {float, float, float},
              optional(any) => any
            }
        ) :: float
  def intersect(triangle, ray) do
    intersection = 0.0

    dividend = Graphmath.Vec3.dot(triangle.a, triangle.normal) - Graphmath.Vec3.dot(ray.eye, triangle.normal)
    divisor = Graphmath.Vec3.dot(ray.direction, triangle.normal)

    t = dividend/divisor

    p = Graphmath.Vec3.add(ray.eye, Graphmath.Vec3.scale(ray.direction, t))

    v2 = Graphmath.Vec3.subtract(p, triangle.a)
    v0 = Graphmath.Vec3.subtract(triangle.b, triangle.a)
    v1 = Graphmath.Vec3.subtract(triangle.c, triangle.a)

    dot20 = Graphmath.Vec3.dot(v2, v0)
    dot00 = Graphmath.Vec3.dot(v0, v0)
    dot10 = Graphmath.Vec3.dot(v1, v0)
    dot21 = Graphmath.Vec3.dot(v2, v1)
    dot11 = Graphmath.Vec3.dot(v1, v1)

    alpha = ((dot11 * dot20) - (dot10 * dot21)) / ((dot00 * dot11) - (dot10 * dot10))
    beta = ((dot00 * dot21) - (dot10 * dot20)) / ((dot00 * dot11) - (dot10 * dot10))

    intersection = cond do
      alpha >= 0.0 and alpha <= 1.0 and beta >= 0.0 and beta <= 1.0 and alpha + beta <= 1.0 -> t
      true -> intersection
    end

    %{intersection: intersection, point: compute_point(ray, intersection), normal: triangle.normal}
  end

  def apply_transform(triangle, transform) do
    { a_x, a_y, a_z } = triangle.a
    { a_x, a_y, a_z, _ } = Graphmath.Mat44.apply_left({ a_x, a_y, a_z, 1.0 }, transform)
    a = Graphmath.Vec3.create(a_x, a_y, a_z)
    { b_x, b_y, b_z } = triangle.b
    { b_x, b_y, b_z, _ } = Graphmath.Mat44.apply_left({ b_x, b_y, b_z, 1.0 }, transform)
    b = Graphmath.Vec3.create(b_x, b_y, b_z)
    { c_x, c_y, c_z } = triangle.c
    { c_x, c_y, c_z, _ } = Graphmath.Mat44.apply_left({ c_x, c_y, c_z, 1.0 }, transform)
    c = Graphmath.Vec3.create(c_x, c_y, c_z)
    normal = Graphmath.Vec3.normalize(Graphmath.Vec3.cross(Graphmath.Vec3.subtract(b, a), Graphmath.Vec3.subtract(c, a)))

    %Primitives.Triangle{triangle | a: a, b: b, c: c, normal: normal}
  end

  defp compute_point(ray, lambda) do
    Graphmath.Vec3.add(ray.eye, Graphmath.Vec3.scale(ray.direction, lambda))
  end
end
