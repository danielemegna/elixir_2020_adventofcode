defmodule Advent13 do

  def resolve_first_part() do
    read_input_file_content()
    |> parse_input_file()
    |> bus_id_and_wait_factor()
  end

  def resolve_second_part() do
    read_input_file_content()
    |> parse_input_file()
    |> Map.get(:bus_timetable)
    |> optimized_subsequent_departures_contest()
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

  def optimized_subsequent_departures_contest(bus_timetable) do
    indexed_bus_timetable = bus_timetable
    |> Enum.with_index()
    |> Enum.filter(fn {bus_id, _index} -> bus_id != :out_of_service end)

    first_bus_id = Enum.at(bus_timetable, 0)

    find_with(first_bus_id, Enum.drop(indexed_bus_timetable, 1), first_bus_id, nil)
  end

  def find_with(_pace, [], match_attempt, _first_match) do
    match_attempt
  end

  def find_with(pace, [{next_bus_id, next_bus_id_index} | rest] = bus_timetable, match_attempt, first_match) do

    desiderable_for_next = match_attempt+next_bus_id_index
    match? = rem(desiderable_for_next, next_bus_id) == 0

    if(match?) do
      if(first_match == nil) do
        if(rest == []) do
          match_attempt
        else
          find_with(pace, bus_timetable, match_attempt+pace, match_attempt)
        end
      else
        new_pace = trunc((match_attempt-first_match) / pace) * pace
        find_with(new_pace, rest, first_match, nil)
      end
    else
      find_with(pace, bus_timetable, match_attempt+pace, first_match)
    end
  end

  def subsequent_departures_contest(bus_timetable) do
    indexed_bus_timetable = bus_timetable
    |> Enum.with_index()
    |> Enum.filter(fn {bus_id, _index} -> bus_id != :out_of_service end)

    {greatest_bus_id, greatest_bus_id_index} = indexed_bus_timetable
    |> Enum.max_by(fn {bus_id, _index} -> bus_id end)

    find_earliest_timestamp_with_subsequent_departures_using(
      indexed_bus_timetable, greatest_bus_id, greatest_bus_id_index
    )
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

  defp find_earliest_timestamp_with_subsequent_departures_using(indexed_bus_timetable, bus_id, bus_index, bus_departure \\ 0) do
    first_bus_departure = bus_departure - bus_index

    if every_bus_depart_subsequently_at?(first_bus_departure, indexed_bus_timetable) do
      first_bus_departure
    else
      find_earliest_timestamp_with_subsequent_departures_using(indexed_bus_timetable, bus_id, bus_index, bus_departure + bus_id)
    end
  end

  defp every_bus_depart_subsequently_at?(first_bus_departure, bus_timetable) do
    Enum.all?(bus_timetable, fn {current_bus_id, current_bus_index} ->
      current_bus_desiderata_departure_timestamp = first_bus_departure + current_bus_index
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
