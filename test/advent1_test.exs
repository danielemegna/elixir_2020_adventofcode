defmodule Advent1Test do
  use ExUnit.Case

  test "resolve_first_part_with provided input example" do
    input = [1721, 979, 366, 299, 675, 1456]
    assert Advent1.resolve_first_part_with(input) == 514579
  end

  test "resolve level (first part)" do
    assert Advent1.resolve_first_part == 181044
  end

  test "resolve_second_part_with provided input example" do
    input = [1721, 979, 366, 299, 675, 1456]
    assert Advent1.resolve_second_part_with(input) == 241861950
  end

  @tag :skip # too slow, to be improved
  test "resolve level (second part)" do
    assert Advent1.resolve_second_part == 82660352
  end

end
