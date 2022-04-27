defmodule Advent20Test do
  use ExUnit.Case

  @provided_example_tiles [
    %Tile{ border_bottom: "..###..###", border_left: ".#####..#.", border_right: "...#.##..#", border_top: "..##.#..#.", id: 2311 },
    %Tile{ border_bottom: "#...##.#..", border_left: "##.#..#..#", border_right: ".#####..#.", border_top: "#.##...##.", id: 1951 },
    %Tile{ border_bottom: ".....##...", border_left: "###....##.", border_right: ".#..#.....", border_top: "####...##.", id: 1171 },
    %Tile{ border_bottom: "..##.#..#.", border_left: "#..#......", border_right: "..###.#.#.", border_top: "###.##.#..", id: 1427 },
    %Tile{ border_bottom: "###.##.#..", border_left: "#...##.#.#", border_right: ".....#..#.", border_top: "##.#.#....", id: 1489 },
    %Tile{ border_bottom: "..###.#.#.", border_left: "####...##.", border_right: "...###.#..", border_top: "#....####.", id: 2473 },
    %Tile{ border_bottom: "...#.#.#.#", border_left: ".###..#...", border_right: "#...##.#.#", border_top: "..#.#....#", id: 2971 },
    %Tile{ border_bottom: "#.##...##.", border_left: ".#....####", border_right: "#..#......", border_top: "...#.#.#.#", id: 2729 },
    %Tile{ border_bottom: "..#.###...", border_left: "#..##.#...", border_right: ".#....#...", border_top: "#.#.#####.", id: 3079 }
  ]

  test "resolve first part" do
    assert Advent20.resolve_first_part() == 23_386_616_781_851
  end

  test "four corners check" do
    assert Advent20.four_corner_check(@provided_example_tiles) == 1951 * 3079 * 2971 * 1171
  end

  test "find compatible tiles" do
    tile = %Tile{
      id: 1427,
      border_top: "###.##.#..",
      border_left: "#..#......",
      border_bottom: "..##.#..#.",
      border_right: "..###.#.#.",
    }

    map = Advent20.compatibility_map(tile, @provided_example_tiles)

    assert map == %{id: 1427, top: 1489, left: 2729, bottom: 2311, right: 2473}
  end

  test "find compatible tiles of a corner" do
    tile = %Tile{
      id: 3079,
      border_top: "#.#.#####.",
      border_left: "#..##.#...",
      border_bottom: "..#.###...",
      border_right: ".#....#..."
    }

    map = Advent20.compatibility_map(tile, @provided_example_tiles)

    assert map == %{id: 3079, top: :none, left: 2311, bottom: 2473, right: :none}
  end

  test "parse input file lines" do
    input_file_content = """
    Tile 2311:
    ..##.#..#.
    ##..#.....
    #...##..#.
    ####.#...#
    ##.##.###.
    ##...#.###
    .#.#.#..##
    ..#....#..
    ###...#.#.
    ..###..###

    Tile 1951:
    #.##...##.
    #.####...#
    .....#..##
    #...######
    .##.#....#
    .###.#####
    ###.##.##.
    .###....#.
    ..#.#..#.#
    #...##.#..

    Tile 1171:
    ####...##.
    #..##.#..#
    ##.#..#.#.
    .###.####.
    ..###.####
    .##....##.
    .#...####.
    #.##.####.
    ####..#...
    .....##...

    Tile 1427:
    ###.##.#..
    .#..#.##..
    .#.##.#..#
    #.#.#.##.#
    ....#...##
    ...##..##.
    ...#.#####
    .#.####.#.
    ..#..###.#
    ..##.#..#.

    Tile 1489:
    ##.#.#....
    ..##...#..
    .##..##...
    ..#...#...
    #####...#.
    #..#.#.#.#
    ...#.#.#..
    ##.#...##.
    ..##.##.##
    ###.##.#..

    Tile 2473:
    #....####.
    #..#.##...
    #.##..#...
    ######.#.#
    .#...#.#.#
    .#########
    .###.#..#.
    ########.#
    ##...##.#.
    ..###.#.#.

    Tile 2971:
    ..#.#....#
    #...###...
    #.#.###...
    ##.##..#..
    .#####..##
    .#..####.#
    #..#.#..#.
    ..####.###
    ..#.#.###.
    ...#.#.#.#

    Tile 2729:
    ...#.#.#.#
    ####.#....
    ..#.#.....
    ....#..#.#
    .##..##.#.
    .#.####...
    ####.#.#..
    ##.####...
    ##..#.##..
    #.##...##.

    Tile 3079:
    #.#.#####.
    .#..######
    ..#.......
    ######....
    ####.#..#.
    .#...#.##.
    #.#####.##
    ..#.###...
    ..#.......
    ..#.###...
    """

    tiles = Advent20.parse_input_file(stream_of(input_file_content))

    assert tiles == @provided_example_tiles
  end

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(& &1)
end
