defmodule Materials do
  defstruct diffuse: Color.create(), emission: Color.create(), shininess: 0.0, specular: Color.create(), ambient: Color.create()

  def from() do
    %Materials{}
  end

  def from(diffuse, emission, shininess, specular, ambient) do
    %Materials{diffuse: diffuse, emission: emission, shininess: shininess, specular: specular, ambient: ambient}
  end
end
