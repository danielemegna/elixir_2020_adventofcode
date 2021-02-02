defmodule Advent12Test do
  use ExUnit.Case

  test "new ships start from x: 0 and y: 0" do
    ship = Ship.new()
    assert %{x: 0, y: 0} == ship.position
  end

  test "new ships start facing East" do
    ship = Ship.new()
    assert :east == ship.direction
  end

  describe "new ship moved by cardinal point command" do
    test "on North 10, ends in x: 0, y: 10" do
      new_ship = Ship.move_by(Ship.new(), "N10")
      assert %{x: 0, y: 10} == new_ship.position
    end

    test "on West 15, ends in x: -15, y: 0" do
      new_ship = Ship.move_by(Ship.new(), "W15")
      assert %{x: -15, y: 0} == new_ship.position
    end

    test "on East 2, ends in x: 2, y: 0" do
      new_ship = Ship.move_by(Ship.new(), "E2")
      assert %{x: 2, y: 0} == new_ship.position
    end
    
    test "on South 17, ends in x: 0, y: -17" do
      new_ship = Ship.move_by(Ship.new(), "S17")
      assert %{x: 0, y: -17} == new_ship.position
    end
  end

  describe "moving forward" do
    test "a new ship, moves East" do
      new_ship = Ship.move_by(Ship.new(), "F24")
      assert %{x: 24, y: 0} == new_ship.position
    end

    test "a ship facing North, moves North" do
      ship = Ship.new(:north)
      moved_ship = Ship.move_by(ship, "F10")
      assert %Ship{direction: :north, position: %{x: 0, y: 10}} == moved_ship
    end

    test "a ship facing South, moves South" do
      ship = Ship.new(:south)
      moved_ship = Ship.move_by(ship, "F16")
      assert %Ship{direction: :south, position: %{x: 0, y: -16}} == moved_ship
    end
  end

  describe "turn a new ship" do
    test "90 left, faces North" do
      turned_ship = Ship.move_by(Ship.new(), "L90")
      assert :north == turned_ship.direction
    end

    test "180 left, faces West" do
      turned_ship = Ship.move_by(Ship.new(), "L180")
      assert :west == turned_ship.direction
    end
  end

  describe "turn a ship facing North" do

    test "90 left, faces West" do
      ship = Ship.new(:north)
      turned_ship = Ship.move_by(ship, "L90")
      assert :west == turned_ship.direction
    end

    test "270 left, faces East" do
      ship = Ship.new(:north)
      turned_ship = Ship.move_by(ship, "L270")
      assert :east == turned_ship.direction
    end

    test "180 left, faces South" do
      ship = Ship.new(:north)
      turned_ship = Ship.move_by(ship, "L180")
      assert :south == turned_ship.direction
    end
  end


  #defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

end
