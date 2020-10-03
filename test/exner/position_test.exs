defmodule Exner.PositionTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.Position

  describe "parse/1" do
    test "gives a position when valid" do
      assert Position.parse("a1")
      assert Position.parse("b2")
      assert Position.parse("c3")
      assert Position.parse("d4")
      assert Position.parse("e5")
      assert Position.parse("f6")
      assert Position.parse("g7")
      assert Position.parse("h8")
    end

    test "gives nil when invalid" do
      refute Position.parse("a9")
      refute Position.parse("i8")
      refute Position.parse("z9")
      refute Position.parse("hello")
    end
  end

  describe "up/1" do
    test "gives one square up" do
      assert "a2" |> Position.parse() |> Position.up() == Position.parse("a3")
    end

    test "gives an error at the end of the board" do
      ~w(a8 b8 c8 d8 e8 f8 g8 h8)
      |> Enum.map(&Position.parse/1)
      |> Enum.each(fn position -> refute Position.up(position) end)
    end
  end

  describe "down/1" do
    test "gives one square down" do
      assert "h8" |> Position.parse() |> Position.down() == Position.parse("h7")
    end

    test "gives an error at the left side of the board" do
      ~w(a1 b1 c1 d1 e1 f1 g1 h1)
      |> Enum.map(&Position.parse/1)
      |> Enum.each(fn position -> refute Position.down(position) end)
    end
  end

  describe "left/1" do
    test "gives one square left" do
      assert "h1" |> Position.parse() |> Position.left() == Position.parse("g1")
    end

    test "gives an error at the start of the board" do
      ~w(a1 a2 a3 a4 a5 a6 a7 a8)
      |> Enum.map(&Position.parse/1)
      |> Enum.each(fn position -> refute Position.left(position) end)
    end
  end

  describe "right/1" do
    test "gives one square right" do
      assert "a1" |> Position.parse() |> Position.right() == Position.parse("b1")
    end

    test "gives an error at the right side of the board" do
      ~w(h1 h2 h3 h4 h5 h6 h7 h8)
      |> Enum.map(&Position.parse/1)
      |> Enum.each(fn position -> refute Position.right(position) end)
    end
  end

  describe "up_left/1" do
    test "gives one square left and one square up" do
      assert "h1" |> Position.parse() |> Position.up_left() == Position.parse("g2")
    end

    test "gives an error at the left side and top of the board" do
      ~w(a1 a2 a3 a4 a5 a6 a7 a8 b8 c8 d8 e8 f8 g8 h8)
      |> Enum.map(&Position.parse/1)
      |> Enum.each(fn position -> refute Position.up_left(position) end)
    end
  end

  describe "up_right/1" do
    test "gives one square right and one square up" do
      assert "a1" |> Position.parse() |> Position.up_right() == Position.parse("b2")
    end

    test "gives an error at the right side and top of the board" do
      ~w(h1 h2 h3 h4 h5 h6 h7 a8 b8 c8 d8 e8 f8 g8 h8)
      |> Enum.map(&Position.parse/1)
      |> Enum.each(fn position -> refute Position.up_right(position) end)
    end
  end

  describe "down_left/1" do
    test "gives one square left and one square down" do
      assert "h8" |> Position.parse() |> Position.down_left() == Position.parse("g7")
    end

    test "gives an error at the left side and bottom of the board" do
      ~w(a1 a2 a3 a4 a5 a6 a7 a8 b1 c1 d1 e1 f1 g1 h1)
      |> Enum.map(&Position.parse/1)
      |> Enum.each(fn position -> refute Position.down_left(position) end)
    end
  end

  describe "down_right/1" do
    test "gives one square right and one square down" do
      assert "g8" |> Position.parse() |> Position.down_right() == Position.parse("h7")
    end

    test "gives an error at the right side and bottom of the board" do
      ~w(a1 a2 a3 a4 a5 a6 a7 a8 b1 c1 d1 e1 f1 g1 h1)
      |> Enum.map(&Position.parse/1)
      |> Enum.each(fn position -> refute Position.down_left(position) end)
    end
  end

  describe "to_string/1" do
    test "gives the coordinates" do
      assert "d5" |> Position.parse() |> Position.to_string() == "d5"
    end
  end
end
