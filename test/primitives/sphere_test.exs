defmodule JartTest.Primitives.Sphere do
  use ExUnit.Case
  doctest Primitives.Sphere

  test "a sphere can be generated as a point in origin by default" do
    sphere = Primitives.Sphere.from()
    assert sphere == %Primitives.Sphere{center: Graphmath.Vec3.create(), radius: 0.0}
  end

  test "a sphere has indentity transform matrix by default" do
    sphere = Primitives.Sphere.from()
    assert sphere == %Primitives.Sphere{transform: Graphmath.Mat44.identity()}
  end

  test "a sphere can be generated with a given center and radius" do
    transform = Graphmath.Mat44.identity()
    sphere = Primitives.Sphere.from(Graphmath.Vec3.create(5, 8, -122), 677.22, transform)
    assert sphere == %Primitives.Sphere{
      center: Graphmath.Vec3.create(5, 8, -122),
      radius: 677.22,
      transform: transform
    }
  end
end
