defmodule Advent13Test do
  use ExUnit.Case

  test "given an arrival time and a schedule then you will get the closest time of departure" do
    assert Advent13.closest_time_of_departure(939, 59) == 944
  end

end
