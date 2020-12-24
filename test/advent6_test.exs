defmodule Advent6Test do
  use ExUnit.Case

  @answers_file_content """
  abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b
  """

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(&(&1))

  test "resolve first part" do
    assert Advent6.resolve_first_part() == 6703
  end

  test "resolve second part" do
    assert Advent6.resolve_second_part() == 3430
  end

  test "sum different answers from file content" do
    assert Advent6.sum_different_answers(stream_of(@answers_file_content)) == 3 + 3 + 3 + 1 + 1
  end

  test "sum answered by entire group from file content" do
    assert Advent6.sum_answered_by_entire_group(stream_of(@answers_file_content)) == 3 + 0 + 1 + 1 + 1
  end

end
