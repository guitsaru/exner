defmodule Exner.State.QueenMovesTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State.QueenMoves

  describe "moves/1" do
    test "starting moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = QueenMoves.moves(4, state.board)

      assert Enum.count(moves) == 0
    end

    test "all free moves" do
      fen = "8/8/8/3Q4/8/8/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = QueenMoves.moves(36, state.board)

      assert Enum.count(moves) == 27
    end

    test "blocked by same color" do
      fen = "8/8/8/3Q4/8/1P6/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = QueenMoves.moves(36, state.board)

      assert Enum.count(moves) == 25
    end

    test "with attack" do
      fen = "8/8/8/3Q4/8/1p6/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = QueenMoves.moves(36, state.board)

      assert Enum.count(moves) == 26
    end
  end
end
