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

  describe "alive_neighbors" do

    setup do
      alive_cubes = [
        {1,0,0},
        {2,1,0},
        {0,2,0},
        {1,2,0},
        {2,2,0}
      ]
      [c: alive_cubes]
    end

    test "of an alive cube", %{c: alive_cubes} do
      assert 1 == Advent17.alive_neighbors(alive_cubes, {1,0,0})
      assert 3 == Advent17.alive_neighbors(alive_cubes, {2,1,0})
      assert 3 == Advent17.alive_neighbors(alive_cubes, {1,2,0})
    end

    test "of a dead cube in known limits", %{c: alive_cubes} do
      assert 3 == Advent17.alive_neighbors(alive_cubes, {0,1,0})
      assert 5 == Advent17.alive_neighbors(alive_cubes, {1,1,0})
    end

    test "of a dead cube out known limits in same layer", %{c: alive_cubes} do
      assert 1 == Advent17.alive_neighbors(alive_cubes, {0,-1,0})
      assert 3 == Advent17.alive_neighbors(alive_cubes, {1,3,0})
      assert 0 == Advent17.alive_neighbors(alive_cubes, {-99,99,0})
    end

    test "of a dead cube in another layer", %{c: alive_cubes} do
      assert 5 == Advent17.alive_neighbors(alive_cubes, {1,1,-1})
      assert 5 == Advent17.alive_neighbors(alive_cubes, {1,1,1})
      assert 3 == Advent17.alive_neighbors(alive_cubes, {1,3,-1})
      assert 0 == Advent17.alive_neighbors(alive_cubes, {1,1,99})
      assert 0 == Advent17.alive_neighbors(alive_cubes, {1,1,-99})
    end

  end

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(&(&1))

end
