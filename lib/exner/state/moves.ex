defmodule Exner.State.Moves do
  @moduledoc "A behavior used to calculate psuedo legal moves for a piece type"

  alias Exner.{Move, Position, State}

  @spec __using__(any) :: any
  defmacro __using__(_opts) do
    quote do
      @behaviour Exner.State.Moves

      @impl true
      def threatened_squares(position, state) do
        position
        |> moves(state)
        |> Enum.map(& &1.to)
      end

      defoverridable threatened_squares: 2
    end
  end

  @doc "Returns all possible moves for a given position"
  @callback moves(Position.t(), State.t()) :: [Move.t()]

  @doc "Returns all positions threatened by the piece"
  @callback threatened_squares(Position.t(), State.t()) :: [Position.t()]

  @spec position_blocked?(Position.t() | :error, State.t()) :: boolean()
  def position_blocked?(nil, _state), do: true

  def position_blocked?(position, state) do
    case Exner.Board.at(state.board, position) do
      nil -> false
      piece -> piece.color == state.active
    end
  end
end
