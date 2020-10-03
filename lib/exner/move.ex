defmodule Exner.Move do
  @moduledoc "A chess move"

  alias Exner.Position

  @enforce_keys [:from, :to]
  defstruct [:from, :to]

  @type t :: %__MODULE__{from: Position.t(), to: Position.t()}
end
