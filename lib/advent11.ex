defmodule WaitingAreaMap do

  def build_from(string_map_lines) do
    string_map_lines
    |> Enum.with_index
    |> Enum.map(fn {line, y} -> 
      map_row = line
      |> String.graphemes()
      |> Enum.with_index
      |> Enum.map(fn {char, x} ->
        seat_state = case char do
          "." -> :floor
          "L" -> :free
          "#" -> :occupied
        end
        {x, seat_state}
      end)
      |> Map.new

      {y, map_row}
    end)
    |> Map.new
  end
  
  def get(map, x, y) do
    case Map.get(map, y) do
      nil -> nil
      row ->  Map.get(row, x)
    end
  end

  def update(map, x, y, seat_state) do
    new_row = map
    |> Map.get(y)
    |> Map.put(x, seat_state)

    Map.put(map, y, new_row)
  end

end

######################################################

defmodule Advent11 do

  def resolve_first_part() do
    read_waiting_area_map_lines()
    |> occupied_seats_on_stable_state()
  end

  def occupied_seats_on_stable_state(string_map_lines) do
    string_map_lines
    |> WaitingAreaMap.build_from()
    |> stable_state_for_map()
    |> Enum.reduce(0, fn {_y, row}, acc ->
      acc + Enum.count(Map.values(row), fn state -> state == :occupied end)
    end)
  end

  def stable_state_for_map(map) do
    new_map = execute_round_on(map)
    if new_map == map do
      new_map
    else
      stable_state_for_map(new_map)
    end
  end

  def execute_round_on(initial_map) do
    Enum.reduce(initial_map, initial_map, fn {y, row}, acc ->
      Enum.reduce(row, acc, fn {x, current_state}, acc ->
        new_seat_state_for(initial_map, x, y, current_state)
        |> case do
          ^current_state -> acc
          new_state -> WaitingAreaMap.update(acc, x, y, new_state)
        end
      end)
    end)
  end

  defp new_seat_state_for(map, x, y, current_state) do
    occupied_adiacents = [
      {x-1, y-1},
      {x-1, y},
      {x-1, y+1},
      {x, y+1},
      {x, y-1},
      {x+1, y-1},
      {x+1, y},
      {x+1, y+1}
    ] |> Enum.count(fn {x, y} ->
      WaitingAreaMap.get(map, x, y) == :occupied
    end)

    case current_state do
      :free when occupied_adiacents == 0 -> :occupied
      :occupied when occupied_adiacents > 3 -> :free
      state -> state
    end
  end

  defp read_waiting_area_map_lines() do
    File.stream!("advent11.txt")
    |> Stream.map(&String.trim/1)
  end

end
