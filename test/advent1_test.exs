defmodule Advent1Test do
  use ExUnit.Case

  test "resolve level" do
    assert Advent1.resolve == 181044
  end

  test "resolve with provided input example" do
    input = [1721, 979, 366, 299, 675, 1456]
    assert Advent1.resolve_with(input) == 514579
  end

end
