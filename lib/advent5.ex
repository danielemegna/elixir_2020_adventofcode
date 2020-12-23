defmodule Seat do
  @enforce_keys [:row, :column]
  defstruct @enforce_keys

  def get_id(seat), do: (seat.row * 8) + seat.column
end

defmodule Advent5 do

  def resolve_first_part() do
    read_seats_file()
    |> Stream.map(&decode_seat/1)
    |> Stream.map(&Seat.get_id/1)
    |> Enum.max
  end

  def resolve_second_part() do
    plane_seats = 0..1023
    busy_seats = read_seats_file()
    |> Stream.map(&decode_seat/1)
    |> Stream.map(&Seat.get_id/1)

    free_seats = MapSet.difference(
      MapSet.new(plane_seats), MapSet.new(busy_seats)
    )

    free_seats |> Enum.find(fn id ->
      !Enum.member?(free_seats, id-1)
        && !Enum.member?(free_seats, id+1)
    end)
  end

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

  defp read_seats_file do
    File.stream!("advent5.txt")
    |> Stream.map(&String.trim/1)
  end

end
