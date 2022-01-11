defmodule CalculatorUtils do

  def close_parenthesis_index_onward(list), do:
    close_parenthesis_index(list, ")")

  def close_parenthesis_index_backwards(list), do:
    -close_parenthesis_index(Enum.reverse(list), "(")

  defp close_parenthesis_index(list, close_char) do
    open_char = case close_char do
      ")" -> "("
      "(" -> ")"
    end

    list
    |> Stream.with_index()
    |> Enum.reduce_while(0, fn {c, idx}, nest_level ->
      case {c, nest_level} do
        {^close_char, 0} -> {:halt, idx}
        {^open_char, _} -> {:cont, nest_level+1}
        {^close_char, _} -> {:cont, nest_level-1}
        _ -> {:cont, nest_level}
      end
    end)
  end

  def to_int(n) when is_integer(n), do: n
  def to_int(b) when is_binary(b), do: String.to_integer(b)
end

defmodule OrderPrecedenceCalculator do
  import CalculatorUtils

  def evaluate(list), do: evaluate(list, {0, :sum})

  defp evaluate(["+" | rest], {accumulated, _}), do:
    evaluate(rest, {accumulated, :sum})

  defp evaluate(["*" | rest], {accumulated, _}), do:
    evaluate(rest, {accumulated, :prod})

  defp evaluate(["(" | rest], {accumulated, next_operation}) do
    close_parenthesis_index = close_parenthesis_index_onward(rest)
    {inner, [_|rest]} = Enum.split(rest, close_parenthesis_index)
    inner_evaluation = evaluate(inner)
    operation_result = calc(accumulated, inner_evaluation, next_operation)
    evaluate(rest, {operation_result, nil})
  end

  defp evaluate([")" | _], {accumulated, _}), do: accumulated
  defp evaluate([], {accumulated, _}), do: accumulated

  defp evaluate([n | rest], {accumulated, next_operation}) do
    operation_result = calc(accumulated, to_int(n), next_operation)
    evaluate(rest, {operation_result, nil})
  end

  defp calc(prev, current, :sum), do: prev + current
  defp calc(prev, current, :prod), do: prev * current

end

defmodule AdditionsPrecedenceCalculator do
  import CalculatorUtils

  def evaluate(list) do
    without_additions = solve_additions(list)
    OrderPrecedenceCalculator.evaluate(without_additions)
  end

  defp solve_additions(list) do
    case Enum.find_index(list, &(&1 == "+")) do
      nil -> list
      n ->
        {left, [_plus | right]} = Enum.split(list, n)
        {l_rest, sum, r_rest} = solve_addition(left, right)
        new_list = l_rest ++ [sum] ++ r_rest
        solve_additions(new_list)
    end
  end

  defp solve_addition(left, right) do
    {l_value, l_rest} = case Enum.split(left, -1) do
      {rest, [")"]} ->
        close_parenthesis_index = close_parenthesis_index_backwards(rest)
        inner = Enum.take(rest, close_parenthesis_index)
        inner_evaluation = evaluate(inner)
        {inner_evaluation, Enum.drop(rest, close_parenthesis_index-1)}
      {rest, [n]} ->
        {to_int(n), rest}
    end

    {r_value, r_rest} = case right do
      ["(" | rest] ->
        close_parenthesis_index = close_parenthesis_index_onward(rest)
        inner = Enum.take(rest, close_parenthesis_index)
        inner_evaluation = evaluate(inner)
        {inner_evaluation, Enum.drop(rest, close_parenthesis_index+1)}
      [n | rest] -> 
        {to_int(n), rest}
    end

    sum = l_value + r_value
    {l_rest, sum, r_rest}
  end

end


########################################

defmodule Advent18 do

  def resolve_first_part do
    read_input_file_content()
    |> Stream.map(&(evaluate_expression(&1, OrderPrecedenceCalculator)))
    |> Enum.sum
  end

  def resolve_second_part do
    read_input_file_content()
    |> Stream.map(&(evaluate_expression(&1, AdditionsPrecedenceCalculator)))
    |> Enum.sum
  end

  def evaluate_expression(string, calculator_module \\ OrderPrecedenceCalculator)
  def evaluate_expression(string, calculator_module) do
    string
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split()
    |> calculator_module.evaluate()
  end

  defp read_input_file_content do
    File.stream!("advent18.txt")
    |> Stream.map(&String.trim/1)
  end

end
