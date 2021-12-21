defmodule Advent15 do

  def resolve_first_part() do
   last_spoken_number_for([13,0,10,12,1,5,8], 2020)
  end

  def last_spoken_number_for(starting_numbers, limit) do
    spoken_numbers_stack_for(starting_numbers, limit) |> Enum.at(0)
  end

  def spoken_numbers_stack_for(starting_numbers, limit) do
    produce_spoken_numbers_stack(Enum.reverse(starting_numbers), limit) 
  end

  defp produce_spoken_numbers_stack(stack, limit) do
    next = next_for(stack)
    new_stack = [next | stack]

    if(limit == Enum.count(new_stack)) do
      new_stack
    else
      produce_spoken_numbers_stack(new_stack, limit)
    end
  end

  def next_for([head | tail]) do
    Enum.find_index(tail, &(&1 == head))
    |> case do
      nil -> 0
      index -> index + 1
    end
  end

end
