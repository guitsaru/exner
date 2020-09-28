defmodule Exner.BoardTest do
  use ExUnit.Case, async: true

  alias Exner.Board

  describe "new/0" do
    test "generates a starting board" do
      assert %Board{} = Board.new()
    end
  end

  describe "new/1" do
    test "generates a board with the given piece locations" do
      pieces = %{1 => %Exner.Piece{color: :white, role: :pawn}}
      assert board = Board.new(pieces)
      assert board[1].color == :white
      assert board[1].role == :pawn

      Enum.each(2..64, fn index -> refute board[index] end)
    end
  end
end
