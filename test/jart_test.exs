defmodule JartTest do
  use ExUnit.Case
  doctest Jart

  test "greets the world" do
    assert Jart.hello() == :world
  end
end
