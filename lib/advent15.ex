defmodule Advent15 do

  def resolve_first_part() do
   last_spoken_number_for([13,0,10,12,1,5,8], 2020)
  end

  def resolve_second_part() do
   last_spoken_number_for([13,0,10,12,1,5,8], 30_000_000)
  end

  def last_spoken_number_for(starting_numbers, limit) do
    spoken_numbers_map_for(starting_numbers, limit).last_spoken
  end

  def spoken_numbers_map_for(starting_numbers, limit) do
    map = init_spoken_numbers_map(starting_numbers)
    produce_spoken_numbers_map(map, limit - Enum.count(starting_numbers))
  end

  def next_number_for(_spoken_numbers_map = m) do
    Map.get(m.already_spoken, m.last_spoken)
    |> case do
      nil -> 0
      n -> m.current_turn - n
    end
  end

  defp produce_spoken_numbers_map(map, 0), do: map
  defp produce_spoken_numbers_map(map, remaining_work) do
    next = next_number_for(map)
    new_map = %{ map |
      already_spoken: Map.put(map.already_spoken, map.last_spoken, map.current_turn),
      last_spoken: next,
      current_turn: map.current_turn+1
    }
    produce_spoken_numbers_map(new_map, remaining_work-1)
  end

  defp init_spoken_numbers_map(starting_numbers) do
    {last_spoken, already_spoken} = List.pop_at(starting_numbers, -1)
    %{
      last_spoken: last_spoken,
      current_turn: Enum.count(starting_numbers),
      already_spoken: Enum.with_index(already_spoken, 1) |> Map.new
    }
  end


end
