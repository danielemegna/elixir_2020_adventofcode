defmodule Advent15Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent15.resolve_first_part() == 260
  end

  @tag :skip
  test "resolve second part" do
    assert Advent15.resolve_second_part() == 950
  end

  describe "last spoken number" do

    test "short case" do
      assert 0 == Advent15.last_spoken_number_for([0,3,6], 4)
      assert 3 == Advent15.last_spoken_number_for([0,3,6], 5)
      assert 3 == Advent15.last_spoken_number_for([0,3,6], 6)
      assert 1 == Advent15.last_spoken_number_for([0,3,6], 7)
      assert 0 == Advent15.last_spoken_number_for([0,3,6], 8)
      assert 4 == Advent15.last_spoken_number_for([0,3,6], 9)
      assert 0 == Advent15.last_spoken_number_for([0,3,6], 10)
    end

    test "with provided examples" do
      assert 436 == Advent15.last_spoken_number_for([0,3,6], 2020)
      assert 1 == Advent15.last_spoken_number_for([1,3,2], 2020)
      assert 10 == Advent15.last_spoken_number_for([2,1,3], 2020)
      assert 27 == Advent15.last_spoken_number_for([1,2,3], 2020)
      assert 78 == Advent15.last_spoken_number_for([2,3,1], 2020)
      assert 438 == Advent15.last_spoken_number_for([3,2,1], 2020)
      assert 1836 == Advent15.last_spoken_number_for([3,1,2], 2020)
    end

  end

  describe "spoken_numbers_map_for" do

    test "init with starting numbers" do
      actual = Advent15.spoken_numbers_map_for([0,3,6], 3)
      expected = %{
        last_spoken: 6,
        current_turn: 3,
        already_spoken: %{0 => 1, 3 => 2}
      }
      assert actual == expected
    end

    test "short case" do
      actual = Advent15.spoken_numbers_map_for([0,3,6], 10)
      expected = %{
        last_spoken: 0,
        current_turn: 10,
        already_spoken: %{0 => 8, 3 => 6, 6 => 3, 1 => 7, 4 => 9}
      }
      assert actual == expected
    end

  end

  describe "spoken_numbers_stack" do

    test "short case" do
      actual = Advent15.spoken_numbers_stack_for([0,3,6], 10)
      assert actual == [0,4,0,1,3,3,0,6,3,0]
    end

  end

  describe "generate next for reverse stack" do

    test "zero for never met numbers" do
      assert Advent15.next_for([6,3,0]) == 0
      assert Advent15.next_for([1,3,3,0,6,3,0]) == 0
    end

    test "already met numbers: the difference between current turn and position where most recently met" do
      assert Advent15.next_for([0,6,3,0]) == (4-1)
      assert Advent15.next_for([3,0,6,3,0]) == (5-2)
      assert Advent15.next_for([0,1,3,3,0,6,3,0]) == (8-4)
    end

  end

  describe "generate next for spoken numbers memory" do

    test "zero for never met numbers" do
      assert Advent15.next_for(%{last_spoken: 9, current_turn: 1, already_spoken: %{}}) == 0
      assert Advent15.next_for(%{last_spoken: 6, current_turn: 3, already_spoken: %{0 => 1, 3 => 2}}) == 0
    end

    test "already met numbers: the difference between current turn and position where most recently met" do
      assert Advent15.next_for(%{
        last_spoken: 0,
        current_turn: 4,
        already_spoken: %{0 => 1, 3 => 2, 6 => 3}
      }) == (4-1)
      assert Advent15.next_for(%{
        last_spoken: 3,
        current_turn: 5,
        already_spoken: %{0 => 4, 3 => 2, 6 => 3}
      }) == (5-2)
      assert Advent15.next_for(%{
        last_spoken: 0,
        current_turn: 8,
        already_spoken: %{0 => 4, 3 => 6, 6 => 3, 1 => 7}
      }) == (8-4)
    end

  end

end
