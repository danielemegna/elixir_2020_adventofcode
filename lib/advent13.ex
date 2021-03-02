defmodule Advent13 do

  def resolve_first_part() do
    read_input_file_content()
    |> parse_input_file()
    |> bus_id_and_wait_factor()
  end

  def bus_id_and_wait_factor(%{arrival_time: arrival_time, bus_timetable: bus_timetable}) do
    {bus_id, bus_departure_time} = earliest_bus_i_can_take(arrival_time, bus_timetable)
    bus_id * (bus_departure_time - arrival_time)
  end

  def parse_input_file(stream) do
    [first_line, second_line] = Enum.to_list(stream)

    bus_timetable = second_line
    |> String.split(",")
    |> Enum.map(fn
      "x" -> :out_of_service
      bus_id -> String.to_integer(bus_id)
    end)

    %{
      arrival_time: String.to_integer(first_line),
      bus_timetable: bus_timetable
    }
  end

  def earliest_bus_i_can_take(arrival_time, bus_timetable) do
    bus_timetable
    |> Enum.filter(fn bus_id -> bus_id != :out_of_service end)
    |> Enum.map(fn bus_id ->
      bus_departure_time = closest_time_of_departure(arrival_time, bus_id)
      {bus_id, bus_departure_time}
    end)
    |> Enum.min_by(fn {_bus_id, bus_departure_time} -> bus_departure_time end)
  end

  defp closest_time_of_departure(arrival_time, bus_id) do
    closest_time_of_departure(arrival_time, bus_id, bus_id)
  end

  defp closest_time_of_departure(arrival_time, next_bus_departure_time, bus_id) do
    if arrival_time <= next_bus_departure_time do
      next_bus_departure_time
    else
      closest_time_of_departure(arrival_time, next_bus_departure_time+bus_id, bus_id)
    end
  end

  defp read_input_file_content() do
    File.stream!("advent13.txt")
    |> Stream.map(&String.trim/1)
  end

end
