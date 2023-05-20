defmodule JartTest.Point do
  use ExUnit.Case
  doctest Point

  test "a point light can be transformed" do
    point = Point.from(Graphmath.Vec3.create(), Color.from(Graphmath.Vec3.create(1.0, 1.0, 1.0)), Graphmath.Vec3.create(1.0, 0.0, 0.0), Graphmath.Vec3.create(1.0, 0.0, 0.0))
    translate = Graphmath.Mat44.make_translate(4.0, 2.0, 0.0)
    assert Point.apply_transform(point, translate) == Point.from(
      Graphmath.Vec3.create(4.0, 2.0, 0.0),
      Color.from(Graphmath.Vec3.create(1.0, 1.0, 1.0)),
      Graphmath.Vec3.create(1.0, 0.0, 0.0),
      Graphmath.Vec3.create(1.0, 0.0, 0.0)
    )
  end

  test "a point light can compute direction from an origin" do
    point = Point.from(Graphmath.Vec3.create(), Color.from(Graphmath.Vec3.create(1.0, 1.0, 1.0)), Graphmath.Vec3.create(1.0, 0.0, 0.0), Graphmath.Vec3.create(1.0, 0.0, 0.0))
    assert Point.compute_direction(point, Graphmath.Vec3.create(2.0, 2.0, -2.0)) == Graphmath.Vec3.create(-0.3333333333333333, -0.6666666666666666, 0.6666666666666666)
  end

  test "a point light can compute attenuation given a hitpoint" do
    point = Point.from(Graphmath.Vec3.create(), Color.from(Graphmath.Vec3.create(1.0, 1.0, 1.0)), Graphmath.Vec3.create(1.0, 0.0, 0.0), Graphmath.Vec3.create(1.0, 0.0, 0.0))
    assert Point.compute_attenuation(point, Graphmath.Vec3.create(2.0, 2.0, -2.0)) == 1
  end
end
