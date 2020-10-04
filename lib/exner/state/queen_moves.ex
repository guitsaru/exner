defmodule Exner.State.QueenMoves do
  @moduledoc "Generates all psuedo legal moves for a queen"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 2]

  alias Exner.Move
  alias Exner.State.{BishopMoves, RookMoves}

  @impl true
  @spec moves(Exner.Position.t(), Exner.State.t()) :: [Move.t()]
  def moves(position, state) do
    [
      BishopMoves.moves(position, state),
      RookMoves.moves(position, state)
    ]
    |> Enum.flat_map(& &1)
    |> Enum.reject(&position_blocked?(&1, state))
  end
end
