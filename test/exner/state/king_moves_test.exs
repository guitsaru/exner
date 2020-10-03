defmodule Exner.State.KingMovesTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State.KingMoves

  describe "moves/1" do
    test "starting moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = KingMoves.moves(Exner.Position.parse("e1"), state)

      assert Enum.empty?(moves)
    end

    test "all free moves" do
      fen = "8/8/8/3K4/8/8/8/8 w kq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(Exner.Position.parse("d5"), state)

      assert Enum.count(moves) == 4
    end

    test "blocked by same color" do
      fen = "8/8/8/3B4/3P4/8/8/8 w kq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(Exner.Position.parse("d5"), state)

      assert Enum.count(moves) == 3
    end

    test "with attack" do
      fen = "8/8/8/3B4/3p4/8/8/8 w kq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(Exner.Position.parse("d5"), state)

      assert Enum.count(moves) == 4
    end

    test "kingside castle" do
      fen = "rnbqkbnr/ppp2ppp/8/3p4/4p1P1/5N2/PPPPPPBP/RNBQK2R w KQkq - 0 3"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(Exner.Position.parse("e1"), state)

      assert Enum.count(moves) == 2
      assert Enum.any?(moves, fn move -> move.is_castle? end)
    end

    test "kingside castle through check" do
      fen = "rn1qkbnr/ppp1pppp/8/3B4/8/5N1b/PPPPPP1P/RNBQK2R w KQkq - 1 4"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(Exner.Position.parse("e1"), state)

      refute Enum.any?(moves, fn move -> move.is_castle? end)
    end

    test "kingside castle into check" do
      fen = "rnbqk1nr/ppp1pp1p/6p1/3B4/8/4N3/PPPPPb1P/RNBQK2R w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(Exner.Position.parse("e1"), state)

      refute Enum.any?(moves, fn move -> move.is_castle? end)
    end

    test "queenside castle" do
      fen = "rnbqkbnr/pp1ppppp/2p5/6B1/3P4/2N5/PPPQPPPP/R3KBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(Exner.Position.parse("e1"), state)

      assert Enum.count(moves) == 2
      assert Enum.any?(moves, fn move -> move.is_castle? end)
    end

    test "queenside castle through check" do
      fen = "rn1qkbnr/pp1ppppp/2p5/6B1/2PP1Q2/1bN5/PP2PPPP/R3KBNR w KQkq c3 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(Exner.Position.parse("e1"), state)

      refute Enum.any?(moves, fn move -> move.is_castle? end)
    end

    test "queenside castle into check" do
      fen = "rnbqk1nr/pp1ppppp/2p5/6B1/2PP1Q2/2N1b3/PP2PPPP/R3KBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = KingMoves.moves(Exner.Position.parse("e1"), state)

      refute Enum.any?(moves, fn move -> move.is_castle? end)
    end
  end
end
