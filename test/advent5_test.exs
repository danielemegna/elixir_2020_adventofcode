defmodule Advent5Test do
  use ExUnit.Case

  test "decode seats" do
    assert Advent5.decode_seat("FBFBBFFRLR") == %Seat{row: 44, column: 5}
    assert Advent5.decode_seat("BFFFBBFRRR") == %Seat{row: 70, column: 7}
    assert Advent5.decode_seat("FFFBBBFRRR") == %Seat{row: 14, column: 7}
    assert Advent5.decode_seat("BBFFBBFRLL") == %Seat{row: 102, column: 4}
  end

  test "get seat ID from Seat struct" do
    assert Seat.seat_id(%Seat{row: 44, column: 5}) == 357
    assert Seat.seat_id(%Seat{row: 70, column: 7}) == 567
    assert Seat.seat_id(%Seat{row: 14, column: 7}) == 119
    assert Seat.seat_id(%Seat{row: 102, column: 4}) == 820
  end
end
