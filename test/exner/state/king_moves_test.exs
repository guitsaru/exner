defmodule Exner.State.KingMovesTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State.KingMoves

  describe "moves/1" do
    test "starting moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = KingMoves.moves(3, state.board)

      assert Enum.count(moves) == 0
    end

    test "all free moves" do
      fen = "8/8/8/3K4/8/8/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(36, state.board)

      assert Enum.count(moves) == 4
    end

    test "blocked by same color" do
      fen = "8/8/8/3B4/3P4/8/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(36, state.board)

      assert Enum.count(moves) == 3
    end

    test "with attack" do
      fen = "8/8/8/3B4/3p4/8/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(36, state.board)

      assert Enum.count(moves) == 4
    end
  end
end
