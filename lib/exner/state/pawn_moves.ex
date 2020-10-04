defmodule Exner.State.PawnMoves do
  @moduledoc "Generates all psuedo legal moves for a pawn"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 2]

  alias Exner.{Board, Move, Position, State}

  @impl true
  @spec moves(Position.t(), Exner.State.t()) :: [Move.t()]
  def moves(position, state) do
    [
      default_moves(position, state),
      double_moves(position, state),
      attacks(position, state)
    ]
    |> Enum.flat_map(& &1)
  end

  @impl true
  @spec threatened_squares(Position.t(), Exner.State.t()) :: [Position.t()]
  def threatened_squares(position, state) do
    position
    |> possible_attacks(state)
    |> Enum.map(& &1.to)
  end

  defp default_moves(position, %State{active: :white} = state) do
    position
    |> Position.up()
    |> List.wrap()
    |> Enum.reject(&position_blocked?(&1, state))
    |> Enum.reject(&position_blocked_by_other_color?(&1, state))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp default_moves(position, %State{active: :black} = state) do
    position
    |> Position.down()
    |> List.wrap()
    |> Enum.reject(&position_blocked?(&1, state))
    |> Enum.reject(&position_blocked_by_other_color?(&1, state))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp double_moves(position, %State{active: :white} = state) do
    if Enum.any?(default_moves(position, state)) && Position.file(position) == 2 do
      position
      |> Position.up()
      |> Position.up()
      |> List.wrap()
      |> Enum.reject(&position_blocked?(&1, state))
      |> Enum.reject(&position_blocked_by_other_color?(&1, state))
      |> Enum.map(&%Move{from: position, to: &1})
    else
      []
    end
  end

  defp double_moves(position, %State{active: :black} = state) do
    if Enum.any?(default_moves(position, state)) && Position.file(position) == 7 do
      position
      |> Position.down()
      |> Position.down()
      |> List.wrap()
      |> Enum.reject(&position_blocked?(&1, state))
      |> Enum.reject(&position_blocked_by_other_color?(&1, state))
      |> Enum.map(&%Move{from: position, to: &1})
    else
      []
    end
  end

  defp possible_attacks(position, %State{active: :white}) do
    [Position.up_left(position), Position.up_right(position)]
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp possible_attacks(position, %State{active: :black}) do
    [Position.down_left(position), Position.down_right(position)]
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp attacks(position, %State{active: :white} = state) do
    position
    |> possible_attacks(state)
    |> Enum.filter(&can_attack?(&1, state))
  end

  defp attacks(position, %State{active: :black} = state) do
    position
    |> possible_attacks(state)
    |> Enum.filter(&can_attack?(&1, state))
  end

  defp can_attack?(nil, _), do: false

  defp can_attack?(%Move{to: position}, %State{en_passant: position}), do: true

  defp can_attack?(move, state) do
    case Board.at(state.board, move.to) do
      nil -> false
      %Exner.Piece{color: other} -> state.active != other
    end
  end

  defp position_blocked_by_other_color?(position, state) do
    case Exner.Board.at(state.board, position) do
      nil -> false
      _ -> true
    end
  end
end
