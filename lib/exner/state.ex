defmodule Exner.State do
  @moduledoc "The state of a game after before the next move"

  alias Exner.{Board, Color, Move, Piece, Position}

  @type moves_map :: %{optional(Position.t()) => [Move.t()]}
  @type maybe_position :: Position.t() | nil
  @type t :: %__MODULE__{
          board: Board.t(),
          active: Color.t(),
          en_passant: maybe_position,
          white_can_castle_kingside: boolean,
          white_can_castle_queenside: boolean,
          black_can_castle_kingside: boolean,
          black_can_castle_queenside: boolean
        }

  @enforce_keys [:board, :active]
  defstruct [
    :board,
    :active,
    :en_passant,
    :white_can_castle_kingside,
    :white_can_castle_queenside,
    :black_can_castle_kingside,
    :black_can_castle_queenside
  ]

  @spec new(Board.t(), Color.t()) :: t()
  def new(board, active) do
    %__MODULE__{
      board: board,
      active: active,
      white_can_castle_queenside: true,
      white_can_castle_kingside: true,
      black_can_castle_queenside: true,
      black_can_castle_kingside: true
    }
  end

  @spec move(t(), Move.t()) :: {:ok, t()} | {:error, String.t()}
  def move(state, move) do
    with {:ok, board} <- Board.move(state.board, move),
         color <- Color.other(state.active),
         en_passant <- en_passant(state.board, move),
         {:ok, castle_checked_state} <- check_castle_state(state, move) do
      {:ok, %{castle_checked_state | active: color, board: board, en_passant: en_passant}}
    else
      error -> error
    end
  end

  @spec possible_moves(t()) :: moves_map()
  def possible_moves(state) do
    moves = psuedo_legal_moves(state)

    moves
    |> Enum.map(fn {position, moves} ->
      legal_moves =
        moves
        |> Enum.map(fn move -> {move, move(state, move)} end)
        |> Enum.reject(fn {_, moved_state} -> in_check?(moved_state, state.active) end)
        |> Enum.map(fn {move, _} -> move end)

      {position, legal_moves}
    end)
    |> Enum.into(%{})
  end

  @spec in_check?(t()) :: boolean
  def in_check?(state) do
    case in_check?({:ok, state}, state.active) do
      {:error, _} -> false
      status -> status
    end
  end

  @spec in_checkmate?(t()) :: boolean
  def in_checkmate?(state) do
    in_check?(state)
  end

  defp psuedo_legal_moves(state) do
    movable_pieces =
      state.board
      |> Board.pieces()
      |> Enum.filter(fn {_, piece} -> piece.color == state.active end)
      |> Enum.map(fn {position, piece} -> {position, moves(state, position, piece)} end)

    Enum.into(movable_pieces, %{})
  end

  defp in_check?({:error, message}, _), do: {:error, message}

  defp in_check?({:ok, state}, color) do
    {king_pos, _} =
      state.board
      |> Board.pieces()
      |> Enum.find(fn {_, piece} -> piece.color == color && piece.role == :king end)

    %{state | active: Color.other(color)}
    |> psuedo_legal_moves()
    |> Enum.flat_map(fn {_, moves} -> moves end)
    |> Enum.any?(fn %_{to: pos} -> king_pos == pos end)
  end

  defp moves(state, position, %Piece{role: :pawn}) do
    __MODULE__.PawnMoves.moves(position, state)
  end

  defp moves(state, position, %Piece{role: :knight}) do
    __MODULE__.KnightMoves.moves(position, state)
  end

  defp moves(state, position, %Piece{role: :bishop}) do
    __MODULE__.BishopMoves.moves(position, state)
  end

  defp moves(state, position, %Piece{role: :rook}) do
    __MODULE__.RookMoves.moves(position, state)
  end

  defp moves(state, position, %Piece{role: :queen}) do
    __MODULE__.QueenMoves.moves(position, state)
  end

  defp moves(state, position, %Piece{role: :king}) do
    __MODULE__.KingMoves.moves(position, state)
  end

  defp moves(_, _, _), do: []

  defp en_passant(%Piece{role: :pawn, color: :white}, move) do
    if move.to == move.from |> Position.up() |> Position.up() do
      Position.up(move.from)
    else
      nil
    end
  end

  defp en_passant(%Piece{role: :pawn, color: :black}, move) do
    if move.to == move.from |> Position.down() |> Position.down() do
      Position.down(move.from)
    else
      nil
    end
  end

  defp en_passant(%Piece{} = _, _), do: nil

  defp en_passant(board, move) do
    piece = Board.at(board, move.from)

    en_passant(piece, move)
  end

  defp check_castle_state(%__MODULE__{active: :white} = state, move) do
    piece = Board.at(state.board, move.from)
    king_not_moved = piece.role != :king
    king_rook_not_moved = piece.role != :rook || move.from != Position.parse("h1")
    queen_rook_not_moved = piece.role != :rook || move.from != Position.parse("a1")

    white_can_castle_kingside =
      king_not_moved && king_rook_not_moved && state.white_can_castle_kingside

    white_can_castle_queenside =
      king_not_moved && queen_rook_not_moved && state.white_can_castle_queenside

    new_state = %{
      state
      | white_can_castle_kingside: white_can_castle_kingside,
        white_can_castle_queenside: white_can_castle_queenside
    }

    {:ok, new_state}
  end

  defp check_castle_state(%__MODULE__{active: :black} = state, move) do
    piece = Board.at(state.board, move.from)
    king_not_moved = piece.role != :king
    king_rook_not_moved = piece.role != :rook || move.from != Position.parse("h8")
    queen_rook_not_moved = piece.role != :rook || move.from != Position.parse("a8")

    black_can_castle_kingside =
      king_not_moved && king_rook_not_moved && state.black_can_castle_kingside

    black_can_castle_queenside =
      king_not_moved && queen_rook_not_moved && state.black_can_castle_queenside

    new_state = %{
      state
      | black_can_castle_kingside: black_can_castle_kingside,
        black_can_castle_queenside: black_can_castle_queenside
    }

    {:ok, new_state}
  end
end
