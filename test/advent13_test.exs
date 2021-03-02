defmodule Advent13Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent13.resolve_first_part() == 370
  end

  @tag :skip
  test "subsequent_departures_contest with provided example" do
    parsed_input = %{
      arrival_time: 939,
      bus_timetable: [7,13,:out_of_service,:out_of_service,59,:out_of_service,31,19]
    }

    actual = Advent13.subsequent_departures_contest(parsed_input)

    assert actual == 1068781
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
