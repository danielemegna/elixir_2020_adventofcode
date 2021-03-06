defmodule Advent12Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent12.resolve_first_part() == 1645
  end

  test "resolve second part" do
    assert Advent12.resolve_second_part() == 35292
  end

  test "apply provided example navigation instructions on a new ship" do
    navigation_instructions = """
    F10
    N3
    F7
    R90
    F11
    """

    moved_ship = Advent12.apply_on_new_ship(stream_of(navigation_instructions))

    assert %Ship{orientation: :south, position: %{x: 17, y: -8}} == moved_ship
  end

  test "apply provided example navigation instructions on a new ship with waypoint" do
    navigation_instructions = """
    F10
    N3
    F7
    R90
    F11
    """

    moved_ship = Advent12.apply_on_new_ship_with_waypoint(stream_of(navigation_instructions))

    assert %{x: 214, y: -72} == moved_ship.position
  end

  defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

end

######################################################

defmodule WaypointTest do
  use ExUnit.Case

  test "new waypoint start from x: 10 and y: 1" do
    waypoint = Waypoint.new()
    assert %{x: 10, y: 1} == waypoint.position
  end

  describe "new waypoint moved by cardinal point instruction" do
    test "on North 10, ends in x: 10, y: 11" do
      waypoint = Waypoint.move_by(Waypoint.new(), "N10")
      assert %{x: 10, y: 11} == waypoint.position
    end

    test "on West 15, ends in x: -5, y: 1" do
      waypoint = Waypoint.move_by(Waypoint.new(), "W15")
      assert %{x: -5, y: 1} == waypoint.position
    end
  end
  
  describe "rotate a new waypoint" do
    test "right 90" do
      actual = Waypoint.move_by(Waypoint.new(), "R90")
      assert %{x: 1, y: -10} == actual.position
    end

    test "left 90" do
      actual = Waypoint.move_by(Waypoint.new(), "L90")
      assert %{x: -1, y: 10} == actual.position
    end

    test "left 90 twice" do
      actual = Waypoint.new()
      |> Waypoint.move_by("L90")
      |> Waypoint.move_by("L90")
      assert %{x: -10, y: -1} == actual.position
    end

    test "right and left 180" do
      expected = %{x: -10, y: -1}
      assert Waypoint.move_by(Waypoint.new(), "R180").position == expected
      assert Waypoint.move_by(Waypoint.new(), "L180").position == expected
    end

    test "right 270" do
      actual = Waypoint.move_by(Waypoint.new(), "R270")
      assert %{x: -1, y: 10} == actual.position
    end
  end

  test "waypoint should ignore forward navigation instructions" do
    actual = Waypoint.move_by(Waypoint.new(), "F10")
    assert Waypoint.new() == actual
  end
end

######################################################

defmodule ShipTest do
  use ExUnit.Case

  test "new ships start from x: 0 and y: 0" do
    ship = Ship.new()
    assert %{x: 0, y: 0} == ship.position
  end

  test "new ships start facing East" do
    ship = Ship.new()
    assert :east == ship.orientation
  end

  describe "new ship moved by cardinal point instruction" do
    test "on North 10, ends in x: 0, y: 10" do
      moved_ship = Ship.move_by(Ship.new(), "N10")
      assert %{x: 0, y: 10} == moved_ship.position
    end

    test "on West 15, ends in x: -15, y: 0" do
      moved_ship = Ship.move_by(Ship.new(), "W15")
      assert %{x: -15, y: 0} == moved_ship.position
    end

    test "on East 2, ends in x: 2, y: 0" do
      moved_ship = Ship.move_by(Ship.new(), "E2")
      assert %{x: 2, y: 0} == moved_ship.position
    end
    
    test "on South 17, ends in x: 0, y: -17" do
      moved_ship = Ship.move_by(Ship.new(), "S17")
      assert %{x: 0, y: -17} == moved_ship.position
    end

    test "are ignored providing a waypoint" do
      moved_ship = Ship.move_by(Ship.new(), "N10", Waypoint.new())
      assert Ship.new() == moved_ship
      moved_ship = Ship.move_by(Ship.new(), "W15", Waypoint.new())
      assert Ship.new() == moved_ship
    end
  end

  describe "moving forward" do
    test "a new ship, moves East" do
      moved_ship = Ship.move_by(Ship.new(), "F24")
      assert %{x: 24, y: 0} == moved_ship.position
    end

    test "a ship facing North" do
      ship = %Ship{Ship.new() | orientation: :north}
      moved_ship = Ship.move_by(ship, "F10")
      assert %Ship{orientation: :north, position: %{x: 0, y: 10}} == moved_ship
    end

    test "a ship facing South" do
      ship = %Ship{Ship.new() | orientation: :south}
      moved_ship = Ship.move_by(ship, "F16")
      assert %Ship{orientation: :south, position: %{x: 0, y: -16}} == moved_ship
    end

    test "a ship facing West" do
      ship = %Ship{Ship.new() | orientation: :west}
      moved_ship = Ship.move_by(ship, "F42")
      assert %Ship{orientation: :west, position: %{x: -42, y: 0}} == moved_ship
    end
  end

  describe "moving forward providing a waypoint" do
    test "one step with waypoint in x: 10, y: 0" do
      ship = Ship.new()
      waypoint = %Waypoint{Waypoint.new() | position: %{x: 10, y: 0}}

      moved_ship = Ship.move_by(ship, "F1", waypoint)
      assert %{x: 10, y: 0} == moved_ship.position
    end

    test "three steps with waypoint in x: 10, y: 0" do
      ship = Ship.new()
      waypoint = %Waypoint{Waypoint.new() | position: %{x: 10, y: 0}}

      moved_ship = Ship.move_by(ship, "F3", waypoint)
      assert %{x: 30, y: 0} == moved_ship.position
    end

    test "two steps with waypoint in x: 5, y: -7" do
      ship = Ship.new()
      waypoint = %Waypoint{Waypoint.new() | position: %{x: 5, y: -7}}

      moved_ship = Ship.move_by(ship, "F2", waypoint)
      assert %{x: 10, y: -14} == moved_ship.position
    end

    test "preserve actual ship position" do
      ship = %Ship{Ship.new() | position: %{x: 100, y: -100}}
      waypoint = %Waypoint{Waypoint.new() | position: %{x: -5, y: 7}}

      moved_ship = Ship.move_by(ship, "F3", waypoint)
      assert %{x: 100-15, y: -100+21} == moved_ship.position
    end
  end

  describe "turn a new ship" do
    test "90 left, faces North" do
      turned_ship = Ship.move_by(Ship.new(), "L90")
      assert :north == turned_ship.orientation
    end

    test "180 left, faces West" do
      turned_ship = Ship.move_by(Ship.new(), "L180")
      assert :west == turned_ship.orientation
    end

    test "270 right, faces West" do
      turned_ship = Ship.move_by(Ship.new(), "R270")
      assert :north == turned_ship.orientation
    end

    test "is ignored providing a waypoint" do
      turned_ship = Ship.move_by(Ship.new(), "R90", Waypoint.new())
      assert Ship.new() == turned_ship
      turned_ship = Ship.move_by(Ship.new(), "L270", Waypoint.new())
      assert Ship.new() == turned_ship
    end
  end

  describe "turn a ship facing North" do
    test "90 left, faces West" do
      ship = %Ship{Ship.new() | orientation: :north}
      turned_ship = Ship.move_by(ship, "L90")
      assert :west == turned_ship.orientation
    end

    test "270 left, faces East" do
      ship = %Ship{Ship.new() | orientation: :north}
      turned_ship = Ship.move_by(ship, "L270")
      assert :east == turned_ship.orientation
    end

    test "180 left, faces South" do
      ship = %Ship{Ship.new() | orientation: :north}
      turned_ship = Ship.move_by(ship, "L180")
      assert :south == turned_ship.orientation
    end

    test "90 right, faces East" do
      ship = %Ship{Ship.new() | orientation: :north}
      turned_ship = Ship.move_by(ship, "R90")
      assert :east == turned_ship.orientation
    end

    test "270 right, faces West" do
      ship = %Ship{Ship.new() | orientation: :north}
      turned_ship = Ship.move_by(ship, "R270")
      assert :west == turned_ship.orientation
    end
  end

  describe "manhattan distance from center" do
    test "of a new ship" do
      assert Ship.manhattan_distance_from_center(Ship.new()) == 0
    end

    test "of a moved ship" do
      ship = %Ship{orientation: :north, position: %{x: 22, y: -16}}
      assert Ship.manhattan_distance_from_center(ship) == 22 + 16
      ship = %Ship{orientation: :east, position: %{x: -31, y: 50}}
      assert Ship.manhattan_distance_from_center(ship) == 31 + 50
      ship = %Ship{orientation: :south, position: %{x: -28, y: -32}}
      assert Ship.manhattan_distance_from_center(ship) == 28 + 32
    end
  end

end
