defmodule Primitives.Sphere do
  defstruct center: Graphmath.Vec3.create(), radius: 0.0, transform: Graphmath.Mat44.identity()

  @spec from({any, any, any}, any, [[number]]) :: %Primitives.Sphere{
          center: {any, any, any},
          radius: any,
          transform: [[number]]
        }
  def from(center, radius, transform) do
    %Primitives.Sphere{center: center, radius: radius, transform: transform}
  end

  def from() do
    %Primitives.Sphere{}
  end
end
