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

  def earliest_bus_i_can_take(arrival_time, bus_timetable) do
    bus_timetable
    |> Enum.filter(fn bus_id -> bus_id != :out_of_service end)
    |> Enum.map(fn bus_id ->
      bus_departure_time = closest_time_of_departure(arrival_time, bus_id)
      {bus_id, bus_departure_time}
    end)
    |> Enum.min_by(fn {_bus_id, bus_departure_time} -> bus_departure_time end)
  end

  def subsequent_departures_contest(bus_timetable) do
    indexed_bus_timetable = bus_timetable
    |> Enum.with_index()
    |> Enum.filter(fn {bus_id, _index} -> bus_id != :out_of_service end)

    max_bus_info = indexed_bus_timetable
    |> Enum.max_by(fn {bus_id, _index} -> bus_id end)

    find_earliest_timestamp_with_subsequent_departures(max_bus_info, indexed_bus_timetable)
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

  defp find_earliest_timestamp_with_subsequent_departures({max_bus_id, max_bus_id_index}, indexed_bus_timetable) do
    find_earliest_timestamp_with_subsequent_departures(
      max_bus_id, max_bus_id, max_bus_id_index, indexed_bus_timetable
    )
  end

  defp find_earliest_timestamp_with_subsequent_departures(max_bus_id_departure_to_test, max_bus_id, max_bus_id_index, indexed_bus_timetable) do
    first_bus_departure_to_test = max_bus_id_departure_to_test - max_bus_id_index

    if every_bus_depart_subsequently_at?(first_bus_departure_to_test, indexed_bus_timetable) do
      first_bus_departure_to_test
    else
      find_earliest_timestamp_with_subsequent_departures(max_bus_id_departure_to_test + max_bus_id, max_bus_id, max_bus_id_index, indexed_bus_timetable)
    end
  end

  defp every_bus_depart_subsequently_at?(first_bus_departure_to_test, bus_timetable) do
    Enum.all?(bus_timetable, fn {current_bus_id, current_bus_index} ->
      current_bus_desiderata_departure_timestamp = first_bus_departure_to_test + current_bus_index
      rem(current_bus_desiderata_departure_timestamp, current_bus_id) == 0
    end)
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
