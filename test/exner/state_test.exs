defmodule Exner.StateTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State

  describe "possible_moves/1" do
    test "initial white pawn moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = State.possible_moves(state)
      pawn_moves = moves[Exner.Position.parse("b2")]

      assert Enum.count(pawn_moves) == 2
    end

    test "when a move would put you into check" do
      fen = "k7/8/8/8/8/8/r1PK4/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = State.possible_moves(state)
      pawn_moves = moves[Exner.Position.parse("c2")]

      assert Enum.empty?(pawn_moves)
    end
  end

  describe "en passant" do
    test "has no en passant by default" do
      {:ok, state} = Exner.FEN.starting_board()

      refute state.en_passant
    end

    test "no en passant after non-pawn move" do
      {:ok, state} = Exner.FEN.starting_board()
      move = %Exner.Move{from: Exner.Position.parse("a2"), to: Exner.Position.parse("a4")}
      {:ok, state} = State.move(state, move)
      move = %Exner.Move{from: Exner.Position.parse("a1"), to: Exner.Position.parse("a3")}
      {:ok, state} = State.move(state, move)

      refute state.en_passant
    end

    test "no en passant after regular pawn move" do
      {:ok, state} = Exner.FEN.starting_board()
      from = Exner.Position.parse("a2")
      to = Exner.Position.parse("a3")
      move = %Exner.Move{from: from, to: to}
      {:ok, state} = State.move(state, move)

      refute state.en_passant
    end

    test "can en passant after double pawn move" do
      {:ok, state} = Exner.FEN.starting_board()
      from = Exner.Position.parse("a2")
      to = Exner.Position.parse("a4")
      move = %Exner.Move{from: from, to: to}
      {:ok, state} = State.move(state, move)

      assert state.en_passant == Exner.Position.parse("a3")
    end

    test "can en passant after black double pawn move" do
      {:ok, state} = Exner.FEN.starting_board()
      from = Exner.Position.parse("a2")
      to = Exner.Position.parse("a4")
      move = %Exner.Move{from: from, to: to}
      {:ok, state} = State.move(state, move)
      from = Exner.Position.parse("a7")
      to = Exner.Position.parse("a5")
      move = %Exner.Move{from: from, to: to}
      {:ok, state} = State.move(state, move)

      assert state.en_passant == Exner.Position.parse("a6")
    end
  end

  describe "in_check?/1" do
    test "gives correct answer when not in check" do
      {:ok, state} = Exner.FEN.starting_board()

      refute State.in_check?(state)
    end

    test "gives correct answer when in check" do
      fen = "1nbqkbnr/pppppppp/4r3/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)

      assert State.in_check?(state)
    end
  end

  describe "castle ability" do
    test "gives correct answer when no pieces moved" do
      {:ok, state} = Exner.FEN.starting_board()

      assert state.white_can_castle_kingside
      assert state.white_can_castle_queenside
      assert state.black_can_castle_kingside
      assert state.black_can_castle_queenside
    end

    test "gives correct answer when white king moved" do
      from = Exner.Position.parse("e1")
      to = Exner.Position.parse("e3")
      {:ok, state} = Exner.FEN.starting_board()
      {:ok, state} = State.move(state, %Exner.Move{from: from, to: to})

      refute state.white_can_castle_kingside
      refute state.white_can_castle_queenside
      assert state.black_can_castle_kingside
      assert state.black_can_castle_queenside
    end

    test "gives correct answer when white king's rook moved" do
      from = Exner.Position.parse("h1")
      to = Exner.Position.parse("h3")
      {:ok, state} = Exner.FEN.starting_board()
      {:ok, state} = State.move(state, %Exner.Move{from: from, to: to})

      refute state.white_can_castle_kingside
      assert state.white_can_castle_queenside
      assert state.black_can_castle_kingside
      assert state.black_can_castle_queenside
    end

    test "gives correct answer when white queen's rook moved" do
      fen = "rnbqkbnr/pppp1ppp/8/4p3/P7/8/1PPPPPPP/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      move = %Exner.Move{from: Exner.Position.parse("a1"), to: Exner.Position.parse("a3")}
      {:ok, state} = State.move(state, move)

      assert state.white_can_castle_kingside
      refute state.white_can_castle_queenside
      assert state.black_can_castle_kingside
      assert state.black_can_castle_queenside
    end

    test "gives correct answer when black king moved" do
      fen = "rnbqkbnr/pppp1ppp/8/4p3/2B1P3/8/PPPP1PPP/RNBQK1NR b KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      move = %Exner.Move{from: Exner.Position.parse("e8"), to: Exner.Position.parse("e5")}
      {:ok, state} = State.move(state, move)

      assert state.white_can_castle_kingside
      assert state.white_can_castle_queenside
      refute state.black_can_castle_kingside
      refute state.black_can_castle_queenside
    end

    test "gives correct answer when black king's rook moved" do
      fen = "rnbqkbnr/ppppppp1/8/7p/2B1P3/8/PPPP1PPP/RNBQK1NR b KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      move = %Exner.Move{from: Exner.Position.parse("h8"), to: Exner.Position.parse("h5")}
      {:ok, state} = State.move(state, move)

      assert state.white_can_castle_kingside
      assert state.white_can_castle_queenside
      refute state.black_can_castle_kingside
      assert state.black_can_castle_queenside
    end

    test "gives correct answer when black queen's rook moved" do
      fen = "rnbqkbnr/1ppppppp/8/pB6/4P3/8/PPPP1PPP/RNBQK1NR b KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      move = %Exner.Move{from: Exner.Position.parse("a8"), to: Exner.Position.parse("a5")}
      {:ok, state} = State.move(state, move)

      assert state.white_can_castle_kingside
      assert state.white_can_castle_queenside
      assert state.black_can_castle_kingside
      refute state.black_can_castle_queenside
    end
  end

  describe "in_checkmate?" do
    test "initial board not in checkmate" do
      {:ok, state} = Exner.FEN.starting_board()

      refute State.in_checkmate?(state)
    end

    test "when in check" do
      fen = "rnb1kbnr/pppp1ppp/8/4p3/4P1Pq/5P2/PPPP3P/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)

      refute State.in_checkmate?(state)
    end

    test "when in checkmate" do
      fen = "rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)

      assert State.in_checkmate?(state)
    end
  end

  describe "status" do
    test "initial status" do
      {:ok, state} = Exner.FEN.starting_board()

      assert state.status == :created
      refute state.winner
    end

    test "when put in checkmate" do
      move = %Exner.Move{from: Exner.Position.parse("d8"), to: Exner.Position.parse("h4")}
      fen = "rnbqkbnr/pppp1ppp/8/4p3/6P1/5P2/PPPPP2P/RNBQKBNR w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      {:ok, state} = State.move(state, move)

      assert state.status == :checkmate
      assert state.winner == :white
    end
  end
end
