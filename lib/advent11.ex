defmodule WaitingAreaMap do

  def build_from(string_map_lines) do
    string_map_lines
    |> Enum.with_index
    |> Enum.flat_map(fn {line, y} -> 
      line
      |> String.graphemes()
      |> Enum.with_index
      |> Enum.map(fn {char, x} ->
        seat_state = case char do
          "." -> :floor
          "L" -> :free
          "#" -> :occupied
        end
        {{x, y}, seat_state}
      end)
    end)
    |> Map.new
  end
  
  def get(map, x, y) do
    Map.get(map, {x, y})
  end

  def update(map, x, y, seat_state) do
    Map.put(map, {x, y}, seat_state)
  end

end

######################################################

defmodule AdjacentSeatsTransformationRule do

  def new_state_for(map, x, y, current_state) do
    occupied_adjacents = [
      {x-1, y-1}, {x, y+1}, {x+1, y+1},
      {x-1, y},             {x+1, y},
      {x-1, y+1}, {x, y-1}, {x+1, y-1}
    ]
    |> Enum.count(fn {x, y} ->
      WaitingAreaMap.get(map, x, y) == :occupied
    end)

    case current_state do
      :free when occupied_adjacents == 0 -> :occupied
      :occupied when occupied_adjacents > 3 -> :free
      state -> state
    end
  end

end

defmodule Advent11 do

  def resolve_first_part() do
    read_waiting_area_map_lines()
    |> occupied_seats_on_stable_state(AdjacentSeatsTransformationRule)
  end

  def occupied_seats_on_stable_state(string_map_lines, seat_transformation_rule) do
    string_map_lines
    |> WaitingAreaMap.build_from()
    |> stable_state_for_map(seat_transformation_rule)
    |> Map.values()
    |> Enum.count(fn state -> state == :occupied end)
  end

  def stable_state_for_map(map, seat_transformation_rule) do
    new_map = execute_round_on(map, seat_transformation_rule)
    if new_map == map do
      new_map
    else
      stable_state_for_map(new_map, seat_transformation_rule)
    end
  end

  def execute_round_on(initial_map, seat_transformation_rule) do
    Enum.reduce(initial_map, initial_map, fn {{x, y}, current_state}, acc ->
      seat_transformation_rule.new_state_for(initial_map, x, y, current_state)
      |> case do
        ^current_state -> acc
        new_state -> WaitingAreaMap.update(acc, x, y, new_state)
      end
    end)
  end

  defp read_waiting_area_map_lines() do
    File.stream!("advent11.txt")
    |> Stream.map(&String.trim/1)
  end

end
