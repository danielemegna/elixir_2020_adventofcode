defmodule Advent11Test do
  use ExUnit.Case

  @tag :skip # too slow, to be improved
  test "resolve first part" do
    assert Advent11.resolve_first_part() == 2338
  end

  @tag :skip # too slow, to be improved
  test "resolve second part" do
    assert Advent11.resolve_second_part() == 2134
  end

  describe "at stable state using adjacent seats transformation rule" do

    test "provided example empty map should returns 37" do
      map = """
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
      """

      assert Advent11.occupied_seats_on_stable_state(stream_of(map), AdjacentSeatsTransformationRule) == 37
    end

  end

  describe "at stable state using visibile seats transformation rule" do

    test "provided example empty map should returns 26" do
      map = """
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
      """

      assert Advent11.occupied_seats_on_stable_state(stream_of(map), VisibleSeatsTransformationRule) == 26
    end

  end

  describe "stable state from initial map using adjacent seats transformation rule" do
   
    test "with already stable map" do
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

      assert Advent11.stabilize(initial_map, AdjacentSeatsTransformationRule) == initial_map
    end

    test "with provided example missing one round" do
      initial_map = map_from("""
      #.#L.L#.##
      #LLL#LL.L#
      L.L.L..#..
      #LLL.##.L#
      #.LL.LL.LL
      #.LL#L#.##
      ..L.L.....
      #L#LLLL#L#
      #.LLLLLL.L
      #.#L#L#.##
      """
      )

      stable_map = Advent11.stabilize(initial_map, AdjacentSeatsTransformationRule)

      assert stable_map == map_from("""
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
      """)
    end

    test "with provided example empty map" do
      initial_map = map_from("""
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
      """
      )

      stable_map = Advent11.stabilize(initial_map, AdjacentSeatsTransformationRule)

      assert stable_map == map_from("""
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
      """)
    end

  end

  describe "stable state from initial map using visible seats transformation rule" do

    test "with provided example empty map" do
      initial_map = map_from("""
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
      """
      )

      stable_map = Advent11.stabilize(initial_map, VisibleSeatsTransformationRule)

      assert stable_map == map_from("""
      #.L#.L#.L#
      #LLLLLL.LL
      L.L.L..#..
      ##L#.#L.L#
      L.L#.LL.L#
      #.LLLL#.LL
      ..#.L.....
      LLL###LLL#
      #.LLLLL#.L
      #.L#LL#.L#
      """)
    end

  end

  describe "execute a round using adjacent seats transformation rule" do

    test "on only floor map should not change" do
      initial_map = map_from("""
      ....
      ....
      ....
      """
      )
      assert Advent11.execute_round_on(initial_map, AdjacentSeatsTransformationRule) == initial_map
    end

    test "free seats with no occupied adjacents should become occupied" do
      initial_map = map_from("""
      LL
      LL
      """)

      actual = Advent11.execute_round_on(initial_map, AdjacentSeatsTransformationRule)

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

      assert Advent11.execute_round_on(initial_map, AdjacentSeatsTransformationRule) == initial_map
    end

    test "occupied seats with four (or more) occupied adjacents should become free" do
      initial_map = map_from("""
      LL#
      L##
      #L#
      """)

      actual = Advent11.execute_round_on(initial_map, AdjacentSeatsTransformationRule)

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
      assert Advent11.execute_round_on(initial_map, AdjacentSeatsTransformationRule) == initial_map
    end

  end

  describe "execute a round using visible seats transformation rule" do

    test "on only floor map should not change" do
      initial_map = map_from("""
      ....
      ....
      ....
      """
      )
      actual = Advent11.execute_round_on(initial_map, VisibleSeatsTransformationRule)
      assert actual == initial_map
    end

    test "free seats with no visible occupied seats should become occupied" do
      initial_map = map_from("""
      LL
      LL
      """)

      actual = Advent11.execute_round_on(initial_map, VisibleSeatsTransformationRule)

      expected = map_from("""
      ##
      ##
      """)
      assert actual == expected
    end

    test "free seats with a visible occupied seat should remain free" do
      initial_map = map_from("""
      ..#..
      .....
      ..L..
      .....
      .....
      """)

      actual = Advent11.execute_round_on(initial_map, VisibleSeatsTransformationRule)

      expected = map_from("""
      ..#..
      .....
      ..L..
      .....
      .....
      """)
      assert actual == expected
    end

    test "occupied seats with four visible occupied seats should remain occupied" do
      initial_map = map_from("""
      ..#..
      .....
      .##.#
      .....
      #....
      """)
      actual = Advent11.execute_round_on(initial_map, VisibleSeatsTransformationRule)
      assert actual == initial_map
    end

    test "occupied seats with five (or more) visible occupied seats should become free" do
      initial_map = map_from("""
      ..#..
      .....
      .##.#
      ...#.
      #....
      """)

      actual = Advent11.execute_round_on(initial_map, VisibleSeatsTransformationRule)

      expected = map_from("""
      ..#..
      .....
      .#L.#
      ...#.
      #....
      """)
      assert actual == expected
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

      waiting_area_map = WaitingAreaMap.build_from(stream_of(waiting_area_string_map))

      assert waiting_area_map == %{
        {0, 0} => :free, {1, 0} => :floor, {2, 0} => :free, {3, 0} => :occupied, {4, 0} => :floor, {5, 0} => :free,
        {0, 1} => :free, {1, 1} => :free, {2, 1} => :free, {3, 1} => :free, {4, 1} => :free, {5, 1} => :free,
        {0, 2} => :free, {1, 2} => :floor, {2, 2} => :free, {3, 2} => :floor, {4, 2} => :free, {5, 2} => :floor,
        {0, 3} => :floor, {1, 3} => :occupied, {2, 3} => :occupied, {3, 3} => :occupied, {4, 3} => :floor, {5, 3} => :free
      }
    end

    test "get seat state from map" do
      map = map_from("""
      L.L#.L
      LLLLLL
      L.L.L.
      .###.L
      """)

      assert WaitingAreaMap.get(map, 0, 0) == :free
      assert WaitingAreaMap.get(map, 3, 0) == :occupied
      assert WaitingAreaMap.get(map, 0, 3) == :floor
      assert WaitingAreaMap.get(map, 5, 1) == :free
      assert WaitingAreaMap.get(map, -1, 0) == nil
      assert WaitingAreaMap.get(map, 0, -1) == nil
      assert WaitingAreaMap.get(map, 6, 0) == nil
      assert WaitingAreaMap.get(map, 0, 6) == nil
    end

    test "update seat state" do
      map = map_from("""
      L.L#.L
      LLLLLL
      L.L.L.
      .###.L
      """)

      new_map = map
      |> WaitingAreaMap.update(0, 0, :occupied)
      |> WaitingAreaMap.update(2, 0, :occupied)
      |> WaitingAreaMap.update(3, 1, :occupied)
      |> WaitingAreaMap.update(1, 3, :free)

      assert new_map == map_from("""
      #.##.L
      LLL#LL
      L.L.L.
      .L##.L
      """)
    end

    defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

  end

  defp map_from(multiline_string_map), do: WaitingAreaMap.build_from(stream_of(multiline_string_map))

end
