defmodule Exner.State.PawnMovesTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.Position
  alias Exner.State.PawnMoves

  describe "moves/1" do
    test "initial white pawn moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = PawnMoves.moves(Position.parse("a2"), state)

      assert Enum.count(moves) == 2
    end

    test "white pawn's second move" do
      fen = "rnbqkbnr/pppppppp/8/8/8/P7/1PPPPPPP/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = PawnMoves.moves(Position.parse("a3"), state)

      assert Enum.count(moves) == 1
      assert List.first(moves).from == Position.parse("a3")
      assert List.first(moves).to == Position.parse("a4")
    end

    test "white pawn's second move blocked by other color" do
      fen = "rn1qkbnr/ppp1pppp/3p4/8/4P3/7b/PPPP1PPP/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = PawnMoves.moves(Position.parse("h2"), state)

      assert Enum.empty?(moves)
    end

    test "white pawn at end of board" do
      fen = "Pnbqkbnr/pppppppp/8/8/8/8/1PPPPPPP/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = PawnMoves.moves(Position.parse("a8"), state)

      assert Enum.empty?(moves)
    end

    test "white pawn attacks" do
      fen = "rnbqkbnr/1p1ppppp/8/8/8/p1p5/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = PawnMoves.moves(Position.parse("b2"), state)

      assert Enum.count(moves) == 4
      assert Enum.any?(moves, fn move -> move.to == Position.parse("a3") end)
      assert Enum.any?(moves, fn move -> move.to == Position.parse("c3") end)
    end

    test "white pawn has en passant" do
      fen = "rnbqkbnr/1ppppppp/8/pP6/8/8/1PPPPPPP/RNBQKBNR w KQkq a6 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = PawnMoves.moves(Position.parse("b5"), state)

      assert Enum.count(moves) == 2
      assert Enum.any?(moves, fn move -> move.to == Position.parse("a6") end)
    end
  end
end
