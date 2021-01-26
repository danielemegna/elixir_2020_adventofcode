defmodule WaitingArea do
  
  def build_map_from(string_map_lines) do
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

  def height(map) do
    Enum.count(map)
  end

  def width(map) do
    Map.get(map, 0) |> Enum.count
  end

end

defmodule Advent11 do

  def count_occupied_seats_from(map) do
    case map do
      "." -> 0
      _ -> 1
    end
  end

  def final_state_for_map(map) do
    execute_round_on(map)
  end

  def execute_round_on(initial_map) do
    0..WaitingArea.height(initial_map)-1
    |> Enum.flat_map(fn y ->
      0..WaitingArea.width(initial_map)-1
      |> Enum.map(fn x ->
        {x, y}
      end)
    end)
    |> Enum.reduce(initial_map, fn {x, y}, acc ->
      new_seat_state = new_seat_state_for(initial_map, x, y)
      WaitingArea.update(acc, x, y, new_seat_state)
    end)
  end

  defp new_seat_state_for(map, x, y) do
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
      WaitingArea.get(map, x, y) == :occupied
    end)

    case WaitingArea.get(map, x, y) do
      :free when occupied_adiacents == 0 -> :occupied
      :occupied when occupied_adiacents > 3 -> :free
      state -> state
    end
  end

end
