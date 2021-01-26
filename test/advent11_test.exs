defmodule Advent11Test do
  use ExUnit.Case

  describe "after several evolutions" do

    test "single floor position has no occupied seats" do
      assert Advent11.count_occupied_seats_from(".") == 0
    end

    test "single free seat should become occupied" do
      assert Advent11.count_occupied_seats_from("L") == 1
    end

    test "single occupied seat should remain occupied" do
      assert Advent11.count_occupied_seats_from("#") == 1
    end

  end

  describe "execute a round" do
    test "on only floor map should not change" do
      initial_map = map_from("""
      ....
      ....
      ....
      """
      )
      assert Advent11.execute_round_on(initial_map) == initial_map
    end

    test "free seats with no occupied adjacents should become occupied" do
      initial_map = map_from("""
      LL
      LL
      """)

      actual = Advent11.execute_round_on(initial_map)

      expected = map_from("""
      ##
      ##
      """)
      assert actual == expected
    end

    test "free seats with an occupied adjacent should remain free" do
      initial_map = map_from("""
      LLL
      L#L
      LLL
      """)

      assert Advent11.execute_round_on(initial_map) == initial_map
    end

    test "occupied seats with four (or more) occupied adjacents should become free" do
      initial_map = map_from("""
      LL#
      L##
      #L#
      """)

      actual = Advent11.execute_round_on(initial_map)

      expected = map_from("""
      LL#
      LL#
      #L#
      """)
      assert actual == expected
    end

    test "on example provided stable map should not change" do
      initial_map = map_from("""
      #.#L.L#.##
      #LLL#LL.L#
      L.#.L..#..
      #L##.##.L#
      #.#L.LL.LL
      #.#L#L#.##
      ..L.L.....
      #L#L##L#L#
      #.LLLLLL.L
      #.#L#L#.##
      """
      )
      assert Advent11.execute_round_on(initial_map) == initial_map
    end
  end

  describe "waiting area" do 

    test "can be parsed from string" do
      waiting_area_string_map = """
      L.L#.L
      LLLLLL
      L.L.L.
      .###.L
      """

      waiting_area_map = WaitingArea.build_map_from(stream_of(waiting_area_string_map))

      assert waiting_area_map == %{
        0 => %{ 0 => :free, 1 => :floor, 2 => :free, 3 => :occupied, 4 => :floor, 5 => :free },
        1 => %{ 0 => :free, 1 => :free, 2 => :free, 3 => :free, 4 => :free, 5 => :free },
        2 => %{ 0 => :free, 1 => :floor, 2 => :free, 3 => :floor, 4 => :free, 5 => :floor },
        3 => %{ 0 => :floor, 1 => :occupied, 2 => :occupied, 3 => :occupied, 4 => :floor, 5 => :free }
      }
    end

    test "get seat state from map" do
      map = map_from("""
      L.L#.L
      LLLLLL
      L.L.L.
      .###.L
      """)

      assert WaitingArea.get(map, 0, 0) == :free
      assert WaitingArea.get(map, 3, 0) == :occupied
      assert WaitingArea.get(map, 0, 3) == :floor
      assert WaitingArea.get(map, 5, 1) == :free
      assert WaitingArea.get(map, -1, 0) == nil
      assert WaitingArea.get(map, 0, -1) == nil
      assert WaitingArea.get(map, 6, 0) == nil
      assert WaitingArea.get(map, 0, 6) == nil
    end

    test "get size" do
      map = map_from("""
      L.L#.L
      LLLLLL
      L.L.L.
      .###.L
      """)

      assert WaitingArea.width(map) == 6
      assert WaitingArea.height(map) == 4
    end

    test "update seat state" do
      map = map_from("""
      L.L#.L
      LLLLLL
      L.L.L.
      .###.L
      """)

      new_map = map
      |> WaitingArea.update(0, 0, :occupied)
      |> WaitingArea.update(2, 0, :occupied)
      |> WaitingArea.update(3, 1, :occupied)
      |> WaitingArea.update(1, 3, :free)

      assert new_map == map_from("""
      #.##.L
      LLL#LL
      L.L.L.
      .L##.L
      """)
    end

    defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

  end

  defp map_from(multiline_string_map), do: WaitingArea.build_map_from(stream_of(multiline_string_map))

end
