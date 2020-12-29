defmodule Advent8Test do
  use ExUnit.Case

  @loop_example_program """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  """

  defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

  test "parse instructions" do
    actual = Advent8.parse_instructions(stream_of(@loop_example_program))
    assert actual == [
      {:nop, 0}, {:acc, 1}, {:jmp, 4},
      {:acc, 3}, {:jmp, -3}, {:acc, -99},
      {:acc, 1}, {:jmp, -4}, {:acc, 6}
    ]
  end

  test "single acc instruction program" do
    m = %Machine{}
    assert %Machine{pointer: 0, acc: 0} = m

    m = Machine.run(m, [{:acc, 2}])
    assert %Machine{pointer: 1, acc: 2} = m
  end

  test "handle jmp instruction" do
    m = Machine.run(%Machine{}, [{:jmp, 4}])
    assert %Machine{pointer: 4, acc: 0} = m

    m = Machine.run(%Machine{}, [{:jmp, -8}])
    assert %Machine{pointer: -8, acc: 0} = m
  end
  
  test "handle nop instruction" do
    m = Machine.run(%Machine{}, [{:nop, 0}])
    assert %Machine{pointer: 1, acc: 0} = m

    m = Machine.run(%Machine{}, [{:nop, 99}])
    assert %Machine{pointer: 1, acc: 0} = m
  end

  test "run a simple program" do
    simple_program = """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp +50
    nop +0
    acc +1
    jmp -4
    """
    m = Advent8.run_on_machine(stream_of(simple_program))
    assert m == %Machine{pointer: 54, acc: 5, history: [4, 3, 7, 6, 2, 1, 0]}
  end
end
