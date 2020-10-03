defmodule Exner.State.QueenMoves do
  @moduledoc "Generates all psuedo legal moves for a queen"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 3]

  alias Exner.{Board, Move}
  alias Exner.State.{BishopMoves, RookMoves}

  @spec moves(Exner.Position.t(), Exner.Board.t()) :: [Move.t()]
  def moves(position, board) do
    queen = Board.at(board, position)

    [
      BishopMoves.moves(position, board),
      RookMoves.moves(position, board)
    ]
    |> Enum.flat_map(& &1)
    |> Enum.reject(&position_blocked?(&1, board, queen.color))
    |> Enum.map(&%Move{from: position, to: &1})
  end
end
