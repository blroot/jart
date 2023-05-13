defmodule JartTest.Primitives.Sphere do
  use ExUnit.Case
  doctest Primitives.Sphere

  test "a sphere can be generated as a point in origin by default" do
    sphere = Primitives.Sphere.from()
    assert sphere == %Primitives.Sphere{
      center: Graphmath.Vec3.create(),
      radius: 0.0,
      transform: Graphmath.Mat44.identity(),
      inverse_transform: Graphmath.Mat44.inverse(Graphmath.Mat44.identity())
    }
  end

  test "a sphere can be generated with a given center and radius" do
    transform = Graphmath.Mat44.identity()
    sphere = Primitives.Sphere.from(Graphmath.Vec3.create(5, 8, -122), 677.22, transform)
    assert sphere == %Primitives.Sphere{
      center: Graphmath.Vec3.create(5, 8, -122),
      radius: 677.22,
      transform: Graphmath.Mat44.identity(),
      inverse_transform: Graphmath.Mat44.inverse(Graphmath.Mat44.identity())
    }
  end

  test "a sphere does not intersects with a ray" do
    transform = Graphmath.Mat44.identity()
    ray = Primitives.Ray.from(Graphmath.Vec3.create(14, 15, 0), Graphmath.Vec3.create(0, 0, 1))
    sphere = Primitives.Sphere.from(Graphmath.Vec3.create(0, 0, 0), 14, transform)
    assert Primitives.Sphere.intersect(sphere, ray, transform) > 0.0
  end

  test "a sphere intersects with a ray" do
    transform = Graphmath.Mat44.identity()
    ray = Primitives.Ray.from(Graphmath.Vec3.create(1, 1, 0), Graphmath.Vec3.create(0, 0, 1))
    sphere = Primitives.Sphere.from(Graphmath.Vec3.create(0, 0, 0), 14, transform)
    assert Primitives.Sphere.intersect(sphere, ray, transform) > 0.0
  end
end
