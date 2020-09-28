defmodule Exner.State.PawnMovesTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State.PawnMoves

  describe "moves/1" do
    test "initial white pawn moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = PawnMoves.moves(9, state.board)

      assert Enum.count(moves) == 2
    end

    test "white pawn's second move" do
      fen = "rnbqkbnr/pppppppp/8/8/8/P7/1PPPPPPP/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = PawnMoves.moves(17, state.board)

      assert Enum.count(moves) == 1
      assert List.first(moves).from == 17
      assert List.first(moves).to == 25
    end

    test "white pawn at end of board" do
      fen = "Pnbqkbnr/pppppppp/8/8/8/8/1PPPPPPP/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = PawnMoves.moves(57, state.board)

      assert Enum.empty?(moves)
    end

    test "white pawn attacks" do
      fen = "rnbqkbnr/1p1ppppp/8/8/8/p1p5/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = PawnMoves.moves(10, state.board)

      assert Enum.count(moves) == 4
    end
  end
end
