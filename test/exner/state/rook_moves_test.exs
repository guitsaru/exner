defmodule Exner.State.RookMovesTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State.RookMoves

  describe "moves/1" do
    test "starting moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = RookMoves.moves(Exner.Position.parse("a1"), state.board)

      assert Enum.empty?(moves)
    end

    test "all free moves" do
      fen = "8/8/8/3R4/8/8/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = RookMoves.moves(Exner.Position.parse("d5"), state.board)

      assert Enum.count(moves) == 14
    end

    test "blocked by same color" do
      fen = "8/8/8/3R4/8/3P4/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = RookMoves.moves(Exner.Position.parse("d5"), state.board)

      assert Enum.count(moves) == 11
    end

    test "with attack" do
      fen = "8/8/8/3R4/8/3p4/8/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = RookMoves.moves(Exner.Position.parse("d5"), state.board)

      assert Enum.count(moves) == 12
    end
  end
end
