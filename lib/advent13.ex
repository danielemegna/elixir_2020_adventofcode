defmodule Advent13 do

  def closest_time_of_departure(arrival_time, bus_id) do
    next_departure_time(arrival_time, bus_id, bus_id)
  end

  defp next_departure_time(arrival_time, departure_time, bus_id) do
    if arrival_time <= departure_time do
      departure_time
    else
      next_departure_time(arrival_time, departure_time+bus_id, bus_id)
    end
  end

  #defp read_waiting_area_file_content() do
  #  File.stream!("advent13.txt")
  #  |> Stream.map(&String.trim/1)
  #end

end
