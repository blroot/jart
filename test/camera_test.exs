defmodule JartTest.Camera do
  use ExUnit.Case
  doctest Camera

  test "a camera can be generated in origin" do
    camera = Camera.from(Graphmath.Vec3.create(0.0, 0.0, 1.0), Graphmath.Vec3.create(), Graphmath.Vec3.create(0.0, 1.0, 0.0), 45)
    assert camera == %Camera{
      eye: Graphmath.Vec3.create(0.0, 0.0, 1.0),
      center: Graphmath.Vec3.create(),
      up: Graphmath.Vec3.create(0.0, 1.0, 0.0),
      fov: 0.7853981633974483
    }
  end

  test "build a ray thru some pixel" do
    camera = Camera.from(Graphmath.Vec3.create(0.0, 0.0, 1.0), Graphmath.Vec3.create(), Graphmath.Vec3.create(0.0, 1.0, 0.0), 45)
    assert Camera.ray_thru_pixel(camera, 0, 0, 1024, 768) == Primitives.Ray.from(
      Graphmath.Vec3.create(0.0, 0.0, 1.0),
      Graphmath.Vec3.create(-0.4542154029456638, 0.3405505513776385, -0.8232336786619548)
      )
  end
end
