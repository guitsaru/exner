defmodule Exner.State.BishopMoves do
  @moduledoc "Generates all psuedo legal moves for a bishop"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 2]

  alias Exner.{Board, Move, Position}

  @spec moves(Exner.Position.t(), Exner.State.t()) :: [Move.t()]
  def moves(position, state) do
    [
      follow_diagonal(position, state, &Position.up_left/1),
      follow_diagonal(position, state, &Position.up_right/1),
      follow_diagonal(position, state, &Position.down_left/1),
      follow_diagonal(position, state, &Position.down_right/1)
    ]
    |> Enum.flat_map(& &1)
    |> Enum.reject(&position_blocked?(&1, state))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp follow_diagonal(position, state, direction_fun) do
    case direction_fun.(position) do
      nil ->
        []

      move ->
        if Board.at(state.board, move) == nil do
          [move | follow_diagonal(move, state, direction_fun)]
        else
          [move]
        end
    end
  end
end
