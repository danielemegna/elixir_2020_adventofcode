defmodule Advent13Test do
  use ExUnit.Case

  test "given an arrival time and a schedule then you will get the closest time of departure" do
    assert Advent13.closest_time_of_departure(939, 59) == 944
  end

  test "parse puzzle input" do
    puzzle_input = """
    939
    7,13,x,x,59,x,31,19
    """

    parsed = Advent13.parse_puzzle_input(stream_of(puzzle_input))

    assert parsed == %{
      arrival_time: 939,
      buses: [7,13,:out_of_service,:out_of_service,59,:out_of_service,31,19]
    }
  end

  defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

end
