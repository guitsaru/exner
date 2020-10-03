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
      position = Exner.Position.parse("a1")
      pieces = %{position => %Exner.Piece{color: :white, role: :pawn}}
      assert board = Board.new(pieces)
      assert Exner.Board.at(board, position).color == :white
      assert Exner.Board.at(board, position).role == :pawn

      Enum.each(2..64, fn index -> refute Board.at(board, index) end)
    end
  end

  describe "at/1" do
    test "returns the piece" do
      board = Board.new()
      position = Exner.Position.parse("a1")
      assert Board.at(board, position) == %Exner.Piece{color: :white, role: :rook}
    end

    test "returns nil with no piece" do
      board = Board.new()
      position = Exner.Position.parse("a3")
      refute Board.at(board, position)
    end
  end

  describe "pieces/1" do
    test "returns all pieces" do
      board = Board.new()
      pieces = Board.pieces(board)

      assert Enum.count(pieces) == 32

      assert List.first(pieces) ==
               {Exner.Position.parse("a1"), %Exner.Piece{color: :white, role: :rook}}
    end
  end

  describe "move/2" do
    test "moves the piece" do
      from = Exner.Position.parse("a2")
      to = Exner.Position.parse("a4")
      move = %Exner.Move{from: from, to: to}
      assert {:ok, board} = Board.new() |> Board.move(move)

      refute Board.at(board, from)
      assert Board.at(board, to) == %Exner.Piece{color: :white, role: :pawn}
    end
  end

  describe "to_string/1" do
    test "prints the board" do
      board = Board.new()

      assert String.contains?(to_string(board), "+-")
    end
  end
end
