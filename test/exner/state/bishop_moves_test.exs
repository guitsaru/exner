defmodule Exner.State.BishopMovesTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State.BishopMoves

  describe "moves/1" do
    test "starting moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = BishopMoves.moves(3, state.board)

      assert Enum.count(moves) == 0
    end

    test "all free moves" do
      fen = "8/8/8/3B4/8/8/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = BishopMoves.moves(36, state.board)

      assert Enum.count(moves) == 13
    end

    test "blocked by same color" do
      fen = "8/8/8/3B4/8/1P6/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = BishopMoves.moves(36, state.board)

      assert Enum.count(moves) == 11
    end

    test "with attack" do
      fen = "8/8/8/3B4/8/1p6/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = BishopMoves.moves(36, state.board)

      assert Enum.count(moves) == 12
    end
  end
end
