defmodule Exner.State.KingMoves do
  @moduledoc "Generates all psuedo legal moves for a king"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 2]

  alias Exner.{Move, Position}

  @spec moves(Exner.Position.t(), Exner.State.t()) :: [Move.t()]
  def moves(position, board) do
    moves = [
      Position.up(position),
      Position.down(position),
      Position.left(position),
      Position.right(position)
    ]

    moves
    |> Enum.reject(&position_blocked?(&1, board))
    |> Enum.map(&%Move{from: position, to: &1})
  end
end
