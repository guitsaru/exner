defmodule Exner.State do
  @moduledoc "The state of a game after before the next move"

  alias Exner.{Board, Color, Move, Piece, Position}

  @type moves_map :: %{optional(Position.t()) => [Move.t()]}
  @type t :: %__MODULE__{board: Board.t(), active: Color.t()}
  defstruct [:board, :active]

  @spec new(Board.t(), Color.t()) :: t()
  def new(board, active) do
    %__MODULE__{board: board, active: active}
  end

  @spec move(t(), Move.t()) :: t()
  def move(state, move) do
    board = Board.move(state.board, move)
    color = Color.other(state.active)

    %__MODULE__{board: board, active: color}
  end

  @spec possible_moves(t()) :: moves_map()
  def possible_moves(%__MODULE__{board: board, active: active} = state) do
    moves = psuedo_legal_moves(board, active)

    moves
    |> Enum.map(fn {position, moves} ->
      legal_moves =
        moves
        |> Enum.map(fn move -> {move, move(state, move)} end)
        |> Enum.reject(fn {_, moved_state} -> in_check?(moved_state, active) end)
        |> Enum.map(fn {move, _} -> move end)

      {position, legal_moves}
    end)
    |> Enum.into(%{})
  end

  defp psuedo_legal_moves(board, active) do
    movable_pieces =
      board
      |> Enum.filter(fn {_, piece} -> piece.color == active end)
      |> Enum.map(fn {position, piece} -> {position, moves(board, position, piece)} end)

    Enum.into(movable_pieces, %{})
  end

  defp in_check?(state, color) do
    {king_pos, _} =
      Enum.find(state.board, fn {_, piece} -> piece.color == color && piece.role == :king end)

    state.board
    |> psuedo_legal_moves(Color.other(color))
    |> Enum.flat_map(fn {_, moves} -> moves end)
    |> Enum.any?(fn %_{to: pos} -> king_pos == pos end)
  end

  defp moves(board, position, %Piece{role: :pawn}) do
    __MODULE__.PawnMoves.moves(position, board)
  end

  defp moves(board, position, %Piece{role: :knight}) do
    __MODULE__.KnightMoves.moves(position, board)
  end

  defp moves(board, position, %Piece{role: :bishop}) do
    __MODULE__.BishopMoves.moves(position, board)
  end

  defp moves(board, position, %Piece{role: :rook}) do
    __MODULE__.RookMoves.moves(position, board)
  end

  defp moves(board, position, %Piece{role: :queen}) do
    __MODULE__.QueenMoves.moves(position, board)
  end

  defp moves(board, position, %Piece{role: :king}) do
    __MODULE__.KingMoves.moves(position, board)
  end

  defp moves(_, _, _), do: []
end
