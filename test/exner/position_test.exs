defmodule Exner.PositionTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.Position

  describe "up/1" do
    test "gives one square up" do
      assert Position.up(1) == 9
    end

    test "gives an error at the end of the board" do
      Enum.each(57..64, fn position -> assert Position.up(position) == :error end)
    end
  end

  describe "down/1" do
    test "gives one square down" do
      assert Position.down(64) == 56
    end

    test "gives an error at the left side of the board" do
      Enum.each(1..8, fn position -> assert Position.down(position) == :error end)
    end
  end

  describe "left/1" do
    test "gives one square left" do
      assert Position.left(8) == 7
    end

    test "gives an error at the start of the board" do
      Enum.each([1, 9, 17, 25, 33, 41, 49, 57], fn position ->
        assert Position.left(position) == :error
      end)
    end
  end

  describe "right/1" do
    test "gives one square right" do
      assert Position.right(1) == 2
    end

    test "gives an error at the right side of the board" do
      Enum.each([8, 16, 24, 32, 40, 48, 56, 64], fn position ->
        assert Position.right(position) == :error
      end)
    end
  end

  describe "up_left/1" do
    test "gives one square left and one square up" do
      assert Position.up_left(8) == 15
    end

    test "gives an error at the left side of the board" do
      Enum.each([1, 9, 17, 25, 33, 41, 49, 57, 58, 59, 60, 61, 62, 63, 64], fn position ->
        assert Position.up_left(position) == :error
      end)
    end
  end

  describe "up_right/1" do
    test "gives one square right and one square up" do
      assert Position.up_right(1) == 10
    end

    test "gives an error at the right side of the board" do
      Enum.each([8, 16, 24, 32, 40, 48, 56, 57, 58, 59, 60, 61, 62, 63, 64], fn position ->
        assert Position.up_right(position) == :error
      end)
    end
  end

  describe "down_left/1" do
    test "gives one square left and one square down" do
      assert Position.down_left(64) == 55
    end

    test "gives an error at the left side of the board" do
      Enum.each([1, 2, 3, 4, 5, 6, 7, 8, 9, 17, 25, 33, 41, 49, 57], fn position ->
        assert Position.down_left(position) == :error
      end)
    end
  end

  describe "down_right/1" do
    test "gives one square right and one square down" do
      assert Position.down_right(63) == 56
    end

    test "gives an error at the right side of the board" do
      Enum.each([1, 2, 3, 4, 5, 6, 7, 8, 16, 24, 32, 40, 48, 56, 64], fn position ->
        assert Position.down_right(position) == :error
      end)
    end
  end
end
