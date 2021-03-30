defmodule Advent13Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent13.resolve_first_part() == 370
  end

  test "resolve second part" do
    assert Advent13.resolve_second_part() == 894954360381385
  end

  test "optimized_subsequent_departures_contest" do
    assert Advent13.optimized_subsequent_departures_contest([67,7]) == 335
    assert Advent13.optimized_subsequent_departures_contest([67,7,59]) == 6901

    assert Advent13.optimized_subsequent_departures_contest([17,:out_of_service,13,19]) == 3417
    assert Advent13.optimized_subsequent_departures_contest([67,7,59,61]) == 754018
    assert Advent13.optimized_subsequent_departures_contest([67,:out_of_service,7,59,61]) == 779210
    assert Advent13.optimized_subsequent_departures_contest([67,7,:out_of_service,59,61]) == 1261476
    assert Advent13.optimized_subsequent_departures_contest([1789,37,47,1889]) == 1202161486
  end

  test "bus_id_and_wait_factor with provided example" do
    parsed_input = %{
      arrival_time: 939,
      bus_timetable: [7,13,:out_of_service,:out_of_service,59,:out_of_service,31,19]
    }

    actual = Advent13.bus_id_and_wait_factor(parsed_input)

    assert actual == 59*(944-939)
  end

  test "get earliest bus i can take from arrival time and bus timetable" do
    arrival_time = 939
    bus_timetable = [7,13,:out_of_service,:out_of_service,59,:out_of_service,31,19]

    {bus_id, bus_departure_time} = Advent13.earliest_bus_i_can_take(arrival_time, bus_timetable)

    assert bus_id == 59
    assert bus_departure_time == 944
  end

  test "subsequent_departures_contest with provided example" do
    bus_timetable = [7,13,:out_of_service,:out_of_service,59,:out_of_service,31,19]

    actual = Advent13.subsequent_departures_contest(bus_timetable)

    assert actual == 1068781
  end

  test "some other subsequent_departures_contest" do
    assert Advent13.subsequent_departures_contest([17,:out_of_service,13,19]) == 3417
    assert Advent13.subsequent_departures_contest([67,7,59,61]) == 754018
    assert Advent13.subsequent_departures_contest([67,:out_of_service,7,59,61]) == 779210
    assert Advent13.subsequent_departures_contest([67,7,:out_of_service,59,61]) == 1261476
    assert Advent13.subsequent_departures_contest([1789,37,47,1889]) == 1202161486
  end

  test "parse input file" do
    input_file_content = """
    939
    7,13,x,x,59,x,31,19
    """

    parsed = Advent13.parse_input_file(stream_of(input_file_content))

    assert parsed == %{
      arrival_time: 939,
      bus_timetable: [7,13,:out_of_service,:out_of_service,59,:out_of_service,31,19]
    }
  end

  defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

end
