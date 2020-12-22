defmodule Seat do
  @enforce_keys [:row, :column]
  defstruct @enforce_keys

  def seat_id(seat), do: (seat.row * 8) + seat.column
end

defmodule Advent5 do

  def decode_seat(encoded) do
    {row_steps, column_steps} = encoded
    |> String.graphemes()
    |> Enum.split(7)

    %Seat{
      row: reduce_steps(0..127, row_steps),
      column: reduce_steps(0..7, column_steps)
    }
  end

  defp reduce_steps([n], []), do: n
  defp reduce_steps(range, [step | rest_steps]) do
    {head, tail} = Enum.split(range, div(Enum.count(range), 2))

    new_range = case step do
      s when s in ["F", "L"] -> head
      s when s in ["B", "R"] -> tail
    end

    reduce_steps(new_range, rest_steps)
  end

end
