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

  describe "active_neighbors" do

    setup do
      active_cubes = [
        {1,0,0},
        {2,1,0},
        {0,2,0},
        {1,2,0},
        {2,2,0}
      ]
      [c: active_cubes]
    end

    test "of an active cube", %{c: active_cubes} do
      assert 1 == Advent17.active_neighbors(active_cubes, {1,0,0})
      assert 3 == Advent17.active_neighbors(active_cubes, {2,1,0})
      assert 3 == Advent17.active_neighbors(active_cubes, {1,2,0})
    end

    test "of a inactive cube in known limits", %{c: active_cubes} do
      assert 3 == Advent17.active_neighbors(active_cubes, {0,1,0})
      assert 5 == Advent17.active_neighbors(active_cubes, {1,1,0})
    end

    test "of a inactive cube out known limits in same layer", %{c: active_cubes} do
      assert 1 == Advent17.active_neighbors(active_cubes, {0,-1,0})
      assert 3 == Advent17.active_neighbors(active_cubes, {1,3,0})
      assert 0 == Advent17.active_neighbors(active_cubes, {-99,99,0})
    end

    test "of a inactive cube in another layer", %{c: active_cubes} do
      assert 5 == Advent17.active_neighbors(active_cubes, {1,1,-1})
      assert 5 == Advent17.active_neighbors(active_cubes, {1,1,1})
      assert 3 == Advent17.active_neighbors(active_cubes, {1,3,-1})
      assert 0 == Advent17.active_neighbors(active_cubes, {1,1,99})
      assert 0 == Advent17.active_neighbors(active_cubes, {1,1,-99})
    end

  end

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(&(&1))

end
