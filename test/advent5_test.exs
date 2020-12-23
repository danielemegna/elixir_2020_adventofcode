defmodule Advent5Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent5.resolve_first_part() == 848
  end

  test "resolve second part" do
    assert Advent5.resolve_second_part() == 682
  end

  test "decode seats" do
    assert Advent5.decode_seat("FBFBBFFRLR") == %Seat{row: 44, column: 5}
    assert Advent5.decode_seat("BFFFBBFRRR") == %Seat{row: 70, column: 7}
    assert Advent5.decode_seat("FFFBBBFRRR") == %Seat{row: 14, column: 7}
    assert Advent5.decode_seat("BBFFBBFRLL") == %Seat{row: 102, column: 4}
    assert Advent5.decode_seat("FFFFFFFLLL") == %Seat{row: 0, column: 0}
    assert Advent5.decode_seat("BBBBBBBRRR") == %Seat{row: 127, column: 7}
  end

  test "get seat ID from Seat struct" do
    assert Seat.seat_id(%Seat{row: 44, column: 5}) == 357
    assert Seat.seat_id(%Seat{row: 70, column: 7}) == 567
    assert Seat.seat_id(%Seat{row: 14, column: 7}) == 119
    assert Seat.seat_id(%Seat{row: 102, column: 4}) == 820
    assert Seat.seat_id(%Seat{row: 0, column: 0}) == 0
    assert Seat.seat_id(%Seat{row: 0, column: 1}) == 1
    assert Seat.seat_id(%Seat{row: 0, column: 7}) == 7
    assert Seat.seat_id(%Seat{row: 1, column: 0}) == 8
    assert Seat.seat_id(%Seat{row: 127, column: 7}) == 1023
  end
end
