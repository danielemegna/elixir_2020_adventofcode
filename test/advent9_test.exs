defmodule Advent9Test do
  use ExUnit.Case

  @tag :skip # too slow, to be improved
  test "resolve first part" do
    assert Advent9.resolve_first_part() == 556543474
  end

  test "find first invalid with provided example" do
    sequence = [
      35, 20, 15, 25, 47,
      40, 62, 55, 65, 95, 102, 117, 150,
      182, 127, 219, 299, 277, 309, 576
    ] |> Stream.map(&(&1))
    window_size = 5

    assert Advent9.find_first_invalid(sequence, window_size) == 127
  end
end
