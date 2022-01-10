defmodule Advent18 do

  def resolve_first_part do
    read_input_file_content()
    |> Stream.map(&evaluate_expression/1)
    |> Enum.sum
  end

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
    {inner, [_|rest]} = rest |> Enum.split(close_parenthesis_index(rest))
    inner_evaluation = evaluate(inner)
    operation_result = calc(accumulated, inner_evaluation, next_operation)
    evaluate(rest, {operation_result, nil})
  end

  defp evaluate([")" | _], {accumulated, _}), do: accumulated
  defp evaluate([], {accumulated, _}), do: accumulated

  defp evaluate([n | rest], {accumulated, next_operation}) do
    operation_result = calc(accumulated, String.to_integer(n), next_operation)
    evaluate(rest, {operation_result, nil})
  end

  defp calc(prev, current, :sum), do: prev + current
  defp calc(prev, current, :prod), do: prev * current

  defp close_parenthesis_index(list) do
    list
    |> Stream.with_index()
    |> Enum.reduce_while(0, fn {c, idx}, nest_level ->
      case {c, nest_level} do
        {")", 0} -> {:halt, idx}
        {"(", _} -> {:cont, nest_level+1}
        {")", _} -> {:cont, nest_level-1}
        _ -> {:cont, nest_level}
      end
    end)
  end

  defp drop_rest([first | rest], nest_level \\ 0) do
    case {first, nest_level} do
      {")", 0} -> rest
      {")", _} -> drop_rest(rest, nest_level-1)
      {"(", _} -> drop_rest(rest, nest_level+1)
      _ -> drop_rest(rest, nest_level)
    end
  end

  defp read_input_file_content do
    File.stream!("advent18.txt")
    |> Stream.map(&String.trim/1)
  end

end
