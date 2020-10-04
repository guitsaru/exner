defmodule Exner.FEN do
  @moduledoc "Parses FEN into a chess board"

  alias Exner.{Board, Piece, State}

  @starting_fen "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

  @spec starting_board :: {:ok, State.t()} | {:error, String.t()}
  def starting_board, do: parse(@starting_fen)

  @spec parse(String.t()) :: {:ok, State.t()} | {:error, String.t()}
  def parse(fen) do
    with {:ok, [board_fen, active, castles, en_passant | _]} <- split_fen(fen),
         {:ok, board} <- parse_board(board_fen) do
      {:ok,
       %State{
         status: :created,
         board: board,
         active: Exner.Color.parse(active),
         en_passant: Exner.Position.parse(en_passant),
         white_can_castle_kingside: can_white_castle_kingside(castles),
         white_can_castle_queenside: can_white_castle_queenside(castles),
         black_can_castle_kingside: can_black_castle_kingside(castles),
         black_can_castle_queenside: can_black_castle_queenside(castles)
       }}
    else
      response -> response
    end
  end

  defp split_fen(fen) do
    case String.split(fen, " ") do
      [_board_fen, _active | _] = response -> {:ok, response}
      _ -> {:error, "Could not parse FEN"}
    end
  end

  defp parse_board(fen) do
    fen
    |> String.split("/")
    |> Enum.reverse()
    |> Enum.join()
    |> String.split("")
    |> Enum.flat_map(&expand_spaces/1)
    |> Enum.with_index()
    |> Enum.map(fn {piece, index} -> {piece, position_from_index(index)} end)
    |> Enum.map(&parse_piece/1)
    |> build_board()
  end

  defp build_board(pieces) do
    build_board(pieces, %Board{})
  end

  defp build_board([], board), do: {:ok, board}
  defp build_board([{:error, message} | _], _board), do: {:error, message}
  defp build_board([:ignore | tail], board), do: build_board(tail, board)

  defp build_board([{:ok, piece, location} | tail], %Board{pieces: pieces} = board) do
    new_pieces = Map.put(pieces, location, piece)

    build_board(tail, %{board | pieces: new_pieces})
  end

  defp parse_piece({"", _}), do: :ignore
  defp parse_piece({" ", _}), do: :ignore
  defp parse_piece({i, _}) when i in ~w(1 2 3 4 5 6 7 8), do: :ignore
  defp parse_piece({"/", _}), do: :ignore
  defp parse_piece({"P", location}), do: {:ok, %Piece{color: :white, role: :pawn}, location}
  defp parse_piece({"N", location}), do: {:ok, %Piece{color: :white, role: :knight}, location}
  defp parse_piece({"B", location}), do: {:ok, %Piece{color: :white, role: :bishop}, location}
  defp parse_piece({"R", location}), do: {:ok, %Piece{color: :white, role: :rook}, location}
  defp parse_piece({"Q", location}), do: {:ok, %Piece{color: :white, role: :queen}, location}
  defp parse_piece({"K", location}), do: {:ok, %Piece{color: :white, role: :king}, location}
  defp parse_piece({"p", location}), do: {:ok, %Piece{color: :black, role: :pawn}, location}
  defp parse_piece({"n", location}), do: {:ok, %Piece{color: :black, role: :knight}, location}
  defp parse_piece({"b", location}), do: {:ok, %Piece{color: :black, role: :bishop}, location}
  defp parse_piece({"r", location}), do: {:ok, %Piece{color: :black, role: :rook}, location}
  defp parse_piece({"q", location}), do: {:ok, %Piece{color: :black, role: :queen}, location}
  defp parse_piece({"k", location}), do: {:ok, %Piece{color: :black, role: :king}, location}

  defp parse_piece({unknown, location}) do
    {:error, "Could not parse piece \"#{unknown}\" at location #{location}"}
  end

  defp expand_spaces(n) do
    case Integer.parse(n) do
      {x, ""} -> 1..x |> Enum.to_list() |> Enum.map(fn _ -> " " end)
      _ -> [n]
    end
  end

  defp position_from_index(index) do
    rank = Kernel.to_string([Integer.mod(index, 8) + 96])
    file = Kernel.to_string(Integer.floor_div(index, 8) + 1)
    notation = rank <> file
    Exner.Position.parse(notation)
  end

  defp can_white_castle_kingside(castle_string), do: String.contains?(castle_string, "K")
  defp can_white_castle_queenside(castle_string), do: String.contains?(castle_string, "Q")
  defp can_black_castle_kingside(castle_string), do: String.contains?(castle_string, "k")
  defp can_black_castle_queenside(castle_string), do: String.contains?(castle_string, "q")
end
