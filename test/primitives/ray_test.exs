defmodule JartTest.Primitives.Ray do
  use ExUnit.Case
  doctest Primitives.Ray

  test "a ray can be generated in origin with null direction by default" do
    sphere = Primitives.Ray.from()
    assert sphere == %Primitives.Ray{eye: Graphmath.Vec3.create(), direction: Graphmath.Vec3.create()}
  end
end
