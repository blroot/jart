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
end
