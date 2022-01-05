defmodule Advent18 do

  def evaluate_expression(string) do
    string
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split()
    |> evaluate()
  end

  defp evaluate(list), do: evaluate(list, {0, :sum})

  defp evaluate(["+" | rest], {accumulated, _}), do:
    evaluate(rest, {accumulated, :sum})

  defp evaluate(["*" | rest], {accumulated, _}), do:
    evaluate(rest, {accumulated, :prod})

  defp evaluate(["(" | rest], {accumulated, next_operation}) do
    # TODO slice in "inner list" and "rest without it"
    # instead of passing entire rest to evaluate and drop it at the end
    inner_evaluation = evaluate(rest)
    operation_result = calc(accumulated, inner_evaluation, next_operation)
    evaluate(drop_rest(rest), {operation_result, nil})
  end

  defp evaluate([")" | _], {accumulated, _}), do: accumulated
  defp evaluate([], {accumulated, _}), do: accumulated

  defp evaluate([n | rest], {accumulated, next_operation}) do
    operation_result = calc(accumulated, String.to_integer(n), next_operation)
    evaluate(rest, {operation_result, nil})
  end

  defp calc(prev, current, :sum), do: prev + current
  defp calc(prev, current, :prod), do: prev * current

  defp drop_rest([first | rest], nest_level \\ 0) do
    case {first, nest_level} do
      {")", 0} -> rest
      {")", _} -> drop_rest(rest, nest_level-1)
      {"(", _} -> drop_rest(rest, nest_level+1)
      _ -> drop_rest(rest, nest_level)
    end
  end

end
