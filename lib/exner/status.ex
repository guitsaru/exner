defmodule Exner.Status do
  @moduledoc """
  The current status of the game. Can be one of:

  - :created - The game has been created, but has not yet started
  - :started - The game has started
  - :checkmate - The game ended with a checkmate
  - :resigned - One of the players resigned
  - :stalemate - The game ended without a check, but there are no more legal moves
  - :timeout - One of the players lost connection
  - :draw - The players drew
  - :clock - One of the players ran out of time
  - :no_start - The player did not make a first move in time
  """

  @type t ::
          :created
          | :started
          | :checkmate
          | :resigned
          | :stalemate
          | :timeout
          | :draw
          | :clock
          | :no_start
end
