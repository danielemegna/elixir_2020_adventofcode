defmodule Advent3Test do
  use ExUnit.Case

  @trees_map_string """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

  test "resolve first part" do
    assert 268 == Advent3.resolve_first_part()
  end

  test "get map value for visibile coordinates" do
    trees_map = TreesMap.from(@trees_map_string)

    assert TreesMap.at(trees_map, {0, 0}) == :empty
    assert TreesMap.at(trees_map, {2, 0}) == :tree
    assert TreesMap.at(trees_map, {10, 0}) == :empty

    assert TreesMap.at(trees_map, {0, 1}) == :tree
    assert TreesMap.at(trees_map, {2, 1}) == :empty
    assert TreesMap.at(trees_map, {10, 1}) == :empty

    assert TreesMap.at(trees_map, {0, 10}) == :empty
    assert TreesMap.at(trees_map, {1, 10}) == :tree
    assert TreesMap.at(trees_map, {10, 10}) == :tree
  end

  test "get map value on horizontal pattern repeats" do
    trees_map = TreesMap.from(@trees_map_string)

    assert TreesMap.at(trees_map, {11, 0}) == :empty
    assert TreesMap.at(trees_map, {13, 0}) == :tree
    assert TreesMap.at(trees_map, {21, 0}) == :empty

    assert TreesMap.at(trees_map, {11, 1}) == :tree
    assert TreesMap.at(trees_map, {13, 1}) == :empty
    assert TreesMap.at(trees_map, {21, 1}) == :empty

    assert TreesMap.at(trees_map, {11, 10}) == :empty
    assert TreesMap.at(trees_map, {12, 10}) == :tree
    assert TreesMap.at(trees_map, {21, 10}) == :tree
  end

  test "count trees for slope" do
    assert 7 == Advent3.count_trees_for(@trees_map_string, {3, 1})
    assert 2 == Advent3.count_trees_for(@trees_map_string, {1, 1})
  end

end
