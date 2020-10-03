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
      assert Exner.Board.at(board, 1).color == :white
      assert Exner.Board.at(board, 1).role == :pawn

      Enum.each(2..64, fn index -> refute Board.at(board, index) end)
    end
  end

  describe "at/1" do
    test "returns the piece" do
      board = Board.new()
      assert Board.at(board, 1) == %Exner.Piece{color: :white, role: :rook}
    end

    test "returns nil with no piece" do
      board = Board.new()
      refute Board.at(board, 17)
    end
  end

  describe "pieces/1" do
    test "returns all pieces" do
      board = Board.new()
      pieces = Board.pieces(board)

      assert Enum.count(pieces) == 32
      assert List.first(pieces) == {1, %Exner.Piece{color: :white, role: :rook}}
    end
  end

  describe "move/2" do
    test "moves the piece" do
      move = %Exner.Move{from: 9, to: 11}
      assert {:ok, board} = Board.new() |> Board.move(move)

      refute Board.at(board, 9)
      assert Board.at(board, 11) == %Exner.Piece{color: :white, role: :pawn}
    end
  end
end
