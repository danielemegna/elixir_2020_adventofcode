defmodule Advent18 do

  def resolve_first_part do
    read_input_file_content()
    |> Stream.map(&evaluate_expression/1)
    |> Enum.sum
  end

  def resolve_second_part do
    read_input_file_content()
    |> Stream.map(&evaluate_expression_add_precedence/1)
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
    operation_result = calc(accumulated, to_int(n), next_operation)
    evaluate(rest, {operation_result, nil})
  end

  # --------------

  def evaluate_expression_add_precedence(string) do
    string
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split()
    |> evaluate_add_precedence()
  end

  defp evaluate_add_precedence(list) do
    list
    |> solve_sums()
    |> evaluate()
  end

  defp solve_sums(list) do
    Enum.find_index(list, &(&1 == "+"))
    |> case do
      nil -> list
      n ->
        {left, [_plus | right]} = Enum.split(list, n)

        {r_value, r_rest} = case right do
          ["(" | rest] ->
            close_parenthesis_index = close_parenthesis_index(rest)
            inner = Enum.take(rest, close_parenthesis_index)
            inner_evaluation = evaluate_add_precedence(inner)
            {inner_evaluation, Enum.drop(rest, close_parenthesis_index+1)}
          [n | rest] -> 
            {to_int(n), rest}
        end

        {l_rest, [l_value]} = Enum.split(left, -1)

        {l_value, l_rest} = case l_value do
          ")" ->
            close_parenthesis_index = -(close_parenthesis_index(Enum.reverse(l_rest), "(", ")"))
            inner = Enum.take(l_rest, close_parenthesis_index)
            inner_evaluation = evaluate_add_precedence(inner)
            {inner_evaluation, Enum.drop(l_rest, close_parenthesis_index-1)}
          n ->
            {to_int(n), l_rest}
        end

        sum = l_value + r_value
        new_list = l_rest ++ [sum] ++ r_rest
        solve_sums(new_list)
    end
  end

  # --------------

  defp calc(prev, current, :sum), do: prev + current
  defp calc(prev, current, :prod), do: prev * current

  defp close_parenthesis_index(list, close_char \\ ")", open_char \\ "(") do
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

  defp to_int(n) when is_integer(n), do: n
  defp to_int(b) when is_binary(b), do: String.to_integer(b)

  defp read_input_file_content do
    File.stream!("advent18.txt")
    |> Stream.map(&String.trim/1)
  end

end
