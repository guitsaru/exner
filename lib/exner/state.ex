defmodule Exner.State do
  @moduledoc "The state of a game after before the next move"

  alias Exner.{Board, Color, Move, Piece, Position}

  @type t :: %__MODULE__{board: Board.t(), active: Color.t()}
  defstruct [:board, :active]

  @spec new(Board.t(), Color.t()) :: t()
  def new(board, active) do
    %__MODULE__{board: board, active: active}
  end

  @spec possible_moves(t()) :: %{optional(Position.t()) => [Move.t()]}
  def possible_moves(%__MODULE__{board: board, active: active}) do
    psuedo_legal_moves(board, active)
  end

  defp psuedo_legal_moves(board, active) do
    movable_pieces =
      board
      |> Enum.filter(fn {_, piece} -> piece.color == active end)
      |> Enum.map(fn {position, piece} -> {position, moves(board, position, piece)} end)

    Enum.into(movable_pieces, %{})
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
