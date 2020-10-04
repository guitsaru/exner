defmodule Exner.State.PawnMoves do
  @moduledoc "Generates all psuedo legal moves for a pawn"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 2]

  alias Exner.{Board, Move, Position, State}

  @spec moves(Position.t(), Exner.State.t()) :: [Move.t()]
  def moves(position, state) do
    [
      default_moves(position, state),
      double_moves(position, state),
      attacks(position, state)
    ]
    |> Enum.flat_map(& &1)
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

  defp attacks(position, %State{active: :white} = state) do
    [Position.up_left(position), Position.up_right(position)]
    |> Enum.filter(&can_attack?(&1, state))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp attacks(position, %State{active: :black} = state) do
    [Position.down_left(position), Position.down_right(position)]
    |> Enum.filter(&can_attack?(&1, state))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp can_attack?(nil, _), do: false

  defp can_attack?(position, %State{en_passant: position}), do: true

  defp can_attack?(position, state) do
    case Board.at(state.board, position) do
      nil -> false
      %Exner.Piece{color: other} -> state.active != other
    end
  end

  def position_blocked_by_other_color?(position, state) do
    case Exner.Board.at(state.board, position) do
      nil -> false
      _ -> true
    end
  end
end
