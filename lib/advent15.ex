defmodule Advent15 do

  def resolve_first_part() do
   last_spoken_number_for([13,0,10,12,1,5,8], 2020)
  end

  def resolve_second_part() do
   last_spoken_number_for([13,0,10,12,1,5,8], 30_000_000)
  end

  def last_spoken_number_for(starting_numbers, limit) do
    spoken_numbers_stack_for(starting_numbers, limit) |> Enum.at(0)
  end

  def spoken_numbers_stack_for(starting_numbers, limit) do
    produce_spoken_numbers_stack(
      Enum.reverse(starting_numbers),
      limit - Enum.count(starting_numbers)
    )
  end

  defp produce_spoken_numbers_stack(stack, 0), do: stack
  defp produce_spoken_numbers_stack(stack, remaining_work) do
    next = next_for(stack)
    new_stack = [next | stack]

    produce_spoken_numbers_stack(new_stack, remaining_work-1)
  end

  def next_for([head | tail]) do
    Enum.find_index(tail, &(&1 == head))
    |> case do
      nil -> 0
      index -> index + 1
    end
  end

end
