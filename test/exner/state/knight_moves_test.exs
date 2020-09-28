defmodule Exner.State.KnightMovesTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State.KnightMoves

  describe "moves/1" do
    test "starting moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = KnightMoves.moves(2, state.board)

      assert Enum.count(moves) == 2
    end

    test "all free moves" do
      fen = "8/8/8/3N4/8/8/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KnightMoves.moves(36, state.board)

      assert Enum.count(moves) == 8
    end

    test "blocked by same color" do
      fen = "8/8/8/3N4/8/2P5/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KnightMoves.moves(36, state.board)

      assert Enum.count(moves) == 7
    end

    test "with attack" do
      fen = "8/8/8/3B4/8/2p5/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KnightMoves.moves(36, state.board)

      assert Enum.count(moves) == 8
    end
  end
end
