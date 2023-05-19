defmodule JartTest.Primitives.Triangle do
  use ExUnit.Case
  doctest Primitives.Triangle

  test "a triangle is generated with correct normal" do
    triangle = Primitives.Triangle.from(Graphmath.Vec3.create(0, 0, 0), Graphmath.Vec3.create(2, 0, 0), Graphmath.Vec3.create(0, 2, 0))
    assert triangle == %Primitives.Triangle{
      a: Graphmath.Vec3.create(0, 0, 0),
      b: Graphmath.Vec3.create(2, 0, 0),
      c: Graphmath.Vec3.create(0, 2, 0),
      normal: Graphmath.Vec3.create(0.0, 0.0, 1.0)
    }
  end

  test "a triangle intersects with a ray" do
    triangle = Primitives.Triangle.from(Graphmath.Vec3.create(0, 0, 0), Graphmath.Vec3.create(2, 0, 0), Graphmath.Vec3.create(0, 2, 0))
    ray = Primitives.Ray.from(Graphmath.Vec3.create(1, 1, -5), Graphmath.Vec3.create(0, 0, 1))
    assert Primitives.Triangle.intersect(triangle, ray) == %{
      intersection: 5.0,
      normal: Graphmath.Vec3.create(0.0, 0.0, 1.0),
      point: Graphmath.Vec3.create(1.0, 1.0, 0.0)
    }
  end

  test "a triangle does not intersects with a ray" do
    triangle = Primitives.Triangle.from(Graphmath.Vec3.create(0, 0, 0), Graphmath.Vec3.create(2, 0, 0), Graphmath.Vec3.create(0, 2, 0))
    ray = Primitives.Ray.from(Graphmath.Vec3.create(1, 1, 4), Graphmath.Vec3.create(0, 0, 1))
    assert Primitives.Triangle.intersect(triangle, ray) == %{
      intersection: -4.0,
      normal: Graphmath.Vec3.create(0.0, 0.0, 1.0),
      point: Graphmath.Vec3.create(1.0, 1.0, 0.0)
    }
  end

  test "a triangle stays the same if transformed by identity" do
    triangle = Primitives.Triangle.from(Graphmath.Vec3.create(0, 0, 0), Graphmath.Vec3.create(2, 0, 0), Graphmath.Vec3.create(0, 2, 0))
    assert Primitives.Triangle.apply_transform(triangle, Graphmath.Mat44.identity()) == %Primitives.Triangle{
      a: Graphmath.Vec3.create(0, 0, 0),
      b: Graphmath.Vec3.create(2, 0, 0),
      c: Graphmath.Vec3.create(0, 2, 0),
      normal: Graphmath.Vec3.create(0.0, 0.0, 1.0)
    }
  end

  test "a triangle is translated" do
    triangle = Primitives.Triangle.from(Graphmath.Vec3.create(0, 0, 0), Graphmath.Vec3.create(2, 0, 0), Graphmath.Vec3.create(0, 2, 0))
    translate = Graphmath.Mat44.make_translate(2.0, 0.0, 0.0)
    assert Primitives.Triangle.apply_transform(triangle, translate) == %Primitives.Triangle{
      a: Graphmath.Vec3.create(2, 0, 0),
      b: Graphmath.Vec3.create(4, 0, 0),
      c: Graphmath.Vec3.create(2, 2, 0),
      normal: Graphmath.Vec3.create(0.0, 0.0, 1.0)
    }
  end

  test "a triangle is scaled" do
    triangle = Primitives.Triangle.from(Graphmath.Vec3.create(0, 0, 0), Graphmath.Vec3.create(2, 0, 0), Graphmath.Vec3.create(0, 2, 0))
    scale = Graphmath.Mat44.make_scale(0.5, 0.5, 0.5, 1)
    assert Primitives.Triangle.apply_transform(triangle, scale) == %Primitives.Triangle{
      a: Graphmath.Vec3.create(0, 0, 0),
      b: Graphmath.Vec3.create(1, 0, 0),
      c: Graphmath.Vec3.create(0, 1, 0),
      normal: Graphmath.Vec3.create(0.0, 0.0, 1.0)
    }
  end

  test "a triangle is rotated" do
    triangle = Primitives.Triangle.from(Graphmath.Vec3.create(0, 0, 0), Graphmath.Vec3.create(2, 0, 0), Graphmath.Vec3.create(0, 2, 0))
    rotate = Graphmath.Mat44.make_rotate_x(:math.pi/2)
    %{a: {a_x, a_y, a_z}, b: {b_x, b_y, b_z}, c: {c_x, c_y, c_z}} = Primitives.Triangle.apply_transform(triangle, rotate)

    assert {round(a_x), round(a_y), round(a_z)} == {0, 0, 0}
    assert {round(b_x), round(b_y), round(b_z)} == {2, 0, 0}
    assert {round(c_x), round(c_y), round(c_z)} == {0, 0, 2}
  end
end
