defmodule Advent17Test do
  use ExUnit.Case

  test "parse initial configuration" do
    lines = stream_of("""
    .#.
    ..#
    ###
    """)

    actual = Advent17.parse_inital_configuration(lines)

    assert actual == [
      {1,0,0},
      {2,1,0},
      {0,2,0},
      {1,2,0},
      {2,2,0}
    ]
  end

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(&(&1))

end
