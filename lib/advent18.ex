defmodule CalculatorUtils do

  def close_parenthesis_index_onward(list), do:
    close_parenthesis_index(list, ")")

  def close_parenthesis_index_backwards(list), do:
    -(close_parenthesis_index(Enum.reverse(list), "("))-1

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

end

defmodule OrderPrecedenceCalculator do
  import CalculatorUtils

  def evaluate(list), do: evaluate(list, {0, :sum})

  defp evaluate([n | rest], {accumulated, next_operation}) when is_integer(n) do
    operation_result = calc(accumulated, next_operation, n)
    evaluate(rest, {operation_result, nil})
  end

  defp evaluate(["+" | rest], {accumulated, _}), do:
    evaluate(rest, {accumulated, :sum})

  defp evaluate(["*" | rest], {accumulated, _}), do:
    evaluate(rest, {accumulated, :prod})

  defp evaluate(["(" | rest], {accumulated, next_operation}) do
    close_parenthesis_index = close_parenthesis_index_onward(rest)
    {inner, [_close_parenthesis | rest]} = Enum.split(rest, close_parenthesis_index)
    inner_evaluation = evaluate(inner)
    operation_result = calc(accumulated, next_operation, inner_evaluation)
    evaluate(rest, {operation_result, nil})
  end

  defp evaluate([")" | rest], {accumulated, _}), do:
    evaluate(rest, {accumulated, nil})

  defp evaluate([], {accumulated, _}), do: accumulated

  defp calc(prev, :sum, current), do: prev + current
  defp calc(prev, :prod, current), do: prev * current

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
      plus_index ->
        {left, [_plus | right]} = Enum.split(list, plus_index)
        {l_rest, sum, r_rest} = solve_addition(left, right)
        new_list = l_rest ++ [sum] ++ r_rest
        solve_additions(new_list)
    end
  end

  defp solve_addition(left, right) do
    {left_solved, left_rest} = solve_left(left)
    {right_solved, right_rest} = solve_right(right)
    sum = left_solved + right_solved
    {left_rest, sum, right_rest}
  end

  defp solve_left(list) do
    case Enum.split(list, -1) do
      {rest, [value]} when is_integer(value) ->
        {value, rest}
      {rest, [")"]} ->
        close_parenthesis_index = close_parenthesis_index_backwards(rest)
        {rest, [_close_parenthesis | to_solve]} = Enum.split(rest, close_parenthesis_index)
        {evaluate(to_solve), rest}
    end
  end

  defp solve_right(list) do
    case list do
      [n | rest] when is_integer(n) -> 
        {n, rest}
      ["(" | rest] ->
        close_parenthesis_index = close_parenthesis_index_onward(rest)
        {to_solve, [_close_parenthesis | rest]} = Enum.split(rest, close_parenthesis_index)
        {evaluate(to_solve), rest}
    end
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
    |> Enum.map(&try_to_int/1)
    |> calculator_module.evaluate()
  end

  defp try_to_int(string) do
    case Integer.parse(string) do
      :error -> string
      {int, _} -> int
    end
  end

  defp read_input_file_content do
    File.stream!("advent18.txt")
    |> Stream.map(&String.trim/1)
  end

end
