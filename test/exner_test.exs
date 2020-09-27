defmodule ExnerTest do
  use ExUnit.Case
  doctest Exner

  test "greets the world" do
    assert Exner.hello() == :world
  end
end
