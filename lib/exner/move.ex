defmodule Exner.Move do
  @moduledoc "A chess move"

  alias Exner.Position

  @enforce_keys [:from, :to]
  defstruct from: nil, to: nil, is_castle?: false
  @type t :: %__MODULE__{from: Position.t(), to: Position.t(), is_castle?: boolean}
end
