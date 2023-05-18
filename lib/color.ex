defmodule Color do

  def create() do
    Graphmath.Vec3.create()
  end

  def from({x, y, z}) do
    normalize({x, y, z})
  end

  def normalize({x, y, z}) do
    x = cond do
      x > 1.0 -> 1.0
      x < 0.0 -> 0.0
      true -> x
    end

    y = cond do
      y > 1.0 -> 1.0
      y < 0.0 -> 0.0
      true -> y
    end

    z = cond do
      z > 1.0 -> 1.0
      z < 0.0 -> 0.0
      true -> z
    end

    Graphmath.Vec3.create(x, y, z)
  end

  def add(a, b) do
    normalize(Graphmath.Vec3.add(a, b))
  end

  def subtract(a, b) do
    normalize(Graphmath.Vec3.subtract(a, b))
  end

  def scale(a, scale) do
    normalize(Graphmath.Vec3.scale(a, scale))
  end
end
