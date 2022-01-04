defmodule Advent18 do

  def evaluate_expression(string) do
    string
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split()
    |> compute()
  end

  defp compute(list), do: compute(list, {0, :sum})

  defp compute(["+" | rest], {accumulated, _}), do:
    compute(rest, {accumulated, :sum})

  defp compute(["*" | rest], {accumulated, _}), do:
    compute(rest, {accumulated, :prod})

  defp compute(["(" | rest], {accumulated, next_operation}) do
    inner = compute(rest)
    computed = calc(accumulated, inner, next_operation)
    rest = Enum.drop_while(rest, &(&1 != ")"))
    compute(rest, {computed, nil})
  end

  defp compute([")" | _], {accumulated, _}), do: accumulated
  defp compute([], {accumulated, _}), do: accumulated

  defp compute([n | rest], {accumulated, next_operation}) do
    computed = calc(accumulated, String.to_integer(n), next_operation)
    compute(rest, {computed, nil})
  end

  defp calc(prev, current, :sum), do: prev + current
  defp calc(prev, current, :prod), do: prev * current
end
