defmodule Exner.State.KnightMoves do
  @moduledoc "Generates all psuedo legal moves for a knight"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 2]

  alias Exner.{Move, Position}

  @spec moves(Exner.Position.t(), Exner.State.t()) :: [Move.t()]
  def moves(position, state) do
    moves = [
      position |> Position.up() |> Position.up_left(),
      position |> Position.up() |> Position.up_right(),
      position |> Position.down() |> Position.down_left(),
      position |> Position.down() |> Position.down_right(),
      position |> Position.right() |> Position.up_right(),
      position |> Position.right() |> Position.down_right(),
      position |> Position.left() |> Position.up_left(),
      position |> Position.left() |> Position.down_left()
    ]

    moves
    |> Enum.reject(&position_blocked?(&1, state))
    |> Enum.map(&%Move{from: position, to: &1})
  end
end
