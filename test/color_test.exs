defmodule JartTest.Color do
  use ExUnit.Case
  doctest Color

  test "a color can be represented with 3 vectors" do
    color = Color.from(Graphmath.Vec3.create())
    assert color == Graphmath.Vec3.create()
  end

  test "a color is always normalized" do
    color = Color.from(Graphmath.Vec3.create(5.4, 10, -8))
    assert color == Graphmath.Vec3.create(1.0, 1.0, 0.0)
  end

  test "add two colors" do
    color1 = Color.from(Graphmath.Vec3.create(0.5, 1.0, 0.8))
    color2 = Color.from(Graphmath.Vec3.create(0.4, 0.0, 0.2))
    assert Color.add(color1, color2) == Graphmath.Vec3.create(0.9, 1.0, 1.0)
  end

  test "add two colors is normalized" do
    color1 = Color.from(Graphmath.Vec3.create(0.5, 1.0, 0.8))
    color2 = Color.from(Graphmath.Vec3.create(0.6, 0.1, 2.0))
    assert Color.add(color1, color2) == Graphmath.Vec3.create(1.0, 1.0, 1.0)
  end

  test "subtract two colors" do
    color1 = Color.from(Graphmath.Vec3.create(1.0, 1.0, 1.0))
    color2 = Color.from(Graphmath.Vec3.create(0.4, 0.5, 0.2))
    assert Color.subtract(color1, color2) == Graphmath.Vec3.create(0.6, 0.5, 0.8)
  end

  test "subtract two colors is normalized" do
    color1 = Color.from(Graphmath.Vec3.create(0.5, 1.0, 0.8))
    color2 = Color.from(Graphmath.Vec3.create(1.0, 4.0, 2.0))
    assert Color.subtract(color1, color2) == Graphmath.Vec3.create(0.0, 0.0, 0.0)
  end

  test "scale a color" do
    color = Color.from(Graphmath.Vec3.create(0.3, 0.5, 0.0))
    assert Color.scale(color, 2) == Graphmath.Vec3.create(0.6, 1.0, 0.0)
  end

  test "scale a color is normalized" do
    color = Color.from(Graphmath.Vec3.create(1.5, 1.0, 0.8))
    assert Color.scale(color, 2) == Graphmath.Vec3.create(1.0, 1.0, 1.0)
  end
end
