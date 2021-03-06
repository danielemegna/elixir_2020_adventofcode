defmodule WaitingAreaMap do

  def build_from(waiting_area_file_content) do
    waiting_area_file_content
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

######################################################

defmodule VisibleSeatsTransformationRule do

  def new_state_for(map, x, y, current_state) do
    occupied_visibles = [
      find_first_visibile(map, x, y, &south/3),
      find_first_visibile(map, x, y, &north/3),
      find_first_visibile(map, x, y, &east/3),
      find_first_visibile(map, x, y, &west/3),
      find_first_visibile(map, x, y, &south_east/3),
      find_first_visibile(map, x, y, &north_east/3),
      find_first_visibile(map, x, y, &south_west/3),
      find_first_visibile(map, x, y, &north_west/3),
    ] |> Enum.count(&(&1 == :occupied))

    case current_state do
      :free when occupied_visibles == 0 -> :occupied
      :occupied when occupied_visibles > 4 -> :free
      state -> state
    end
  end

  defp south(x, y, n), do: {x, y+n}
  defp north(x, y, n), do: {x, y-n}
  defp east(x, y, n), do: {x+n, y}
  defp west(x, y, n), do: {x-n, y}
  defp south_east(x, y, n), do: {x+n, y+n}
  defp north_east(x, y, n), do: {x+n, y-n}
  defp south_west(x, y, n), do: {x-n, y+n}
  defp north_west(x, y, n), do: {x-n, y-n}

  defp find_first_visibile(map, x, y, direction_fn) do
    Stream.iterate(1, &(&1+1))
    |> Enum.reduce_while(nil, fn n, _ ->
      {visibile_x, visibile_y} = direction_fn.(x, y, n)
      case WaitingAreaMap.get(map, visibile_x, visibile_y) do
        :floor -> {:cont, nil}
        state -> {:halt, state}
      end
    end)
  end

end

######################################################

defmodule Advent11 do

  def resolve_first_part() do
    read_waiting_area_file_content()
    |> occupied_seats_on_stable_state(AdjacentSeatsTransformationRule)
  end

  def resolve_second_part() do
    read_waiting_area_file_content()
    |> occupied_seats_on_stable_state(VisibleSeatsTransformationRule)
  end

  def occupied_seats_on_stable_state(waiting_area_file_content, seat_transformation_rule) do
    stable_map = stabilize(waiting_area_file_content, seat_transformation_rule)

    stable_map
    |> Map.values()
    |> Enum.count(fn state -> state == :occupied end)
  end

  def stabilize(%Stream{} = waiting_area_file_content, seat_transformation_rule) do
    map = WaitingAreaMap.build_from(waiting_area_file_content)
    stabilize(map, seat_transformation_rule)
  end

  def stabilize(map, seat_transformation_rule) when is_map(map) do
    new_map = execute_round_on(map, seat_transformation_rule)
    if new_map == map do
      new_map
    else
      stabilize(new_map, seat_transformation_rule)
    end
  end

  def execute_round_on(initial_map, seat_transformation_rule) do
    Enum.reduce(initial_map, initial_map, fn {{x, y}, current_state}, new_map ->
      new_state = seat_transformation_rule.new_state_for(initial_map, x, y, current_state)
      case new_state do
        ^current_state -> new_map
        _ -> WaitingAreaMap.update(new_map, x, y, new_state)
      end
    end)
  end

  defp read_waiting_area_file_content() do
    File.stream!("advent11.txt")
    |> Stream.map(&String.trim/1)
  end

end
