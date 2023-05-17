defmodule JartTest.Filereader do
  use ExUnit.Case
  doctest Filereader

  test "the size can be parsed from file" do
    Filereader.read("test.scene")
  end
end
