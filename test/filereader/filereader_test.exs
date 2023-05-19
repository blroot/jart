defmodule JartTest.Filereader do
  use ExUnit.Case
  doctest Filereader

  test "the size and output can be parsed from stream" do
    commands = [
      "size 1024 768",
      "output testcrazyscene.png",
    ]
    assert Filereader.read(commands) == %SceneBuilder{width: 1024, height: 768, filename: "testcrazyscene.png"}
  end

  test "the vertices and triangles can be parsed from stream" do
    commands = [
      "vertex -1 -1 -1",
      "vertex +1 -1 -1",
      "vertex +1 -1 +1",
      "tri 0 1 2",
    ]
    assert Filereader.read(commands) == %SceneBuilder{
      triangles: [
        Primitives.Triangle.from(
          Graphmath.Vec3.create(-1.0, -1.0, -1.0),
          Graphmath.Vec3.create(1.0, -1.0, -1.0),
          Graphmath.Vec3.create(1.0, -1.0, 1.0)
        )
      ]
    }
  end

  test "the transforms can be parsed from stream" do
    commands = [
      "translate -0.4 0 0.5",
      "scale 0.5 0.5 0.5",
      "rotate 0 1 1 45"
    ]
    result = Graphmath.Mat44.round(hd(Filereader.read(commands).transformation_stack), 4)
    assert result ==
      Graphmath.Mat44.round(
        Graphmath.Mat44.multiply(
            Graphmath.Mat44.multiply(
              Graphmath.Mat44.multiply(
                Graphmath.Mat44.make_translate(-0.4, 0.0, 0.5),
                Graphmath.Mat44.make_scale(0.5, 0.5, 0.5, 1.0)
              ),
              Graphmath.Mat44.make_rotate_y((:math.pi()/180) * 45)
            ),
            Graphmath.Mat44.make_rotate_z((:math.pi()/180) * 45)
        ), 4)
  end

  test "the transforms can be pushed" do
    commands = [
      "translate -0.4 0 0.5",
      "pushTransform",
      "scale 0.5 0.5 0.5"
    ]
    result = Filereader.read(commands).transformation_stack
    assert result == [
      Graphmath.Mat44.multiply(Graphmath.Mat44.make_translate(-0.4, 0.0, 0.5), Graphmath.Mat44.make_scale(0.5, 0.5, 0.5, 1.0)),
      Graphmath.Mat44.make_translate(-0.4, 0.0, 0.5)
    ]
  end

  test "the transforms can be poped" do
    commands = [
      "translate -0.4 0 0.5",
      "pushTransform",
      "scale 0.5 0.5 0.5",
      "popTransform"
    ]
    result = Filereader.read(commands).transformation_stack
    assert result == [
      Graphmath.Mat44.make_translate(-0.4, 0.0, 0.5)
    ]
  end

  test "materials can be parsed" do
    commands = [
      "diffuse 0 0.2 0",
      "specular 0 1 0",
      "ambient 1 0 0",
      "shininess 70",
      "emission 1 0 0"
    ]
    assert Filereader.read(commands) == %SceneBuilder{
      materials: Materials.from(
        Color.from(Graphmath.Vec3.create(0.0, 0.2, 0.0)),
        Color.from(Graphmath.Vec3.create(1.0, 0.0, 0.0)),
        70.0,
        Color.from(Graphmath.Vec3.create(0.0, 1.0, 0.0)),
        Color.from(Graphmath.Vec3.create(1.0, 0.0, 0.0))
      )
    }
  end

  test "triangle has parsed materials" do
    commands = [
      "diffuse 0 0.2 0",
      "specular 0 1 0",
      "ambient 1 0 0",
      "shininess 70",
      "emission 1 0 0",
      "vertex -1 -1 -1",
      "vertex +1 -1 -1",
      "vertex +1 -1 +1",
      "tri 0 1 2",
    ]
    materials = Materials.from(
      Color.from(Graphmath.Vec3.create(0.0, 0.2, 0.0)),
      Color.from(Graphmath.Vec3.create(1.0, 0.0, 0.0)),
      70.0,
      Color.from(Graphmath.Vec3.create(0.0, 1.0, 0.0)),
      Color.from(Graphmath.Vec3.create(1.0, 0.0, 0.0))
    )
    assert Filereader.read(commands).triangles == [
        Primitives.Triangle.from(
          Graphmath.Vec3.create(-1.0, -1.0, -1.0),
          Graphmath.Vec3.create(1.0, -1.0, -1.0),
          Graphmath.Vec3.create(1.0, -1.0, 1.0),
          materials
        )
      ]
  end
end
