defmodule Advent13 do

  def closest_time_of_departure(arrival_time, bus_id) do
    closest_time_of_departure(arrival_time, bus_id, bus_id)
  end

  def parse_puzzle_input(stream) do
    [first_line, second_line] = Enum.to_list(stream)

    buses = second_line
    |> String.split(",")
    |> Enum.map(fn
      "x" -> :out_of_service
      bus_id -> String.to_integer(bus_id)
    end)

    %{
      arrival_time: String.to_integer(first_line),
      buses: buses
    }
  end

  defp closest_time_of_departure(arrival_time, next_bus_departure_time, bus_id) do
    if arrival_time <= next_bus_departure_time do
      next_bus_departure_time
    else
      closest_time_of_departure(arrival_time, next_bus_departure_time+bus_id, bus_id)
    end
  end

  #defp read_waiting_area_file_content() do
  #  File.stream!("advent13.txt")
  #  |> Stream.map(&String.trim/1)
  #end

end
