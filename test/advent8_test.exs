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

  test "resolve first part" do
    assert Advent8.resolve_first_part() == 2058
  end

  test "resolve second part" do
    assert Advent8.resolve_second_part() == 1000
  end

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

    {:ok, m} = Machine.run(m, [{:acc, 2}])
    assert %Machine{pointer: 1, acc: 2} = m
  end

  test "handle jmp instruction" do
    {:ok, m} = Machine.run(%Machine{}, [{:jmp, 1}])
    assert %Machine{pointer: 1, acc: 0} = m

    {:wrong_pointer, m} = Machine.run(%Machine{}, [{:jmp, 4}])
    assert %Machine{pointer: 4, acc: 0} = m

    {:wrong_pointer, m} = Machine.run(%Machine{}, [{:jmp, -8}])
    assert %Machine{pointer: -8, acc: 0} = m
  end
  
  test "handle nop instruction" do
    {:ok, m} = Machine.run(%Machine{}, [{:nop, 0}])
    assert %Machine{pointer: 1, acc: 0} = m

    {:ok, m} = Machine.run(%Machine{}, [{:nop, 99}])
    assert %Machine{pointer: 1, acc: 0} = m
  end

  test "run a simple program" do
    simple_program = """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp +4
    nop +0
    acc +1
    jmp -4
    acc +2
    """
    {:ok, m} = Advent8.run_on_machine(stream_of(simple_program))
    assert m == %Machine{pointer: 9, acc: 7, history: [8, 4, 3, 7, 6, 2, 1, 0]}
  end

  test "halt on infinite loop (operation already executed)" do
    {:loop, m} = Advent8.run_on_machine(stream_of(@loop_example_program))
    assert m.acc == 5
  end

  test "try to fix the infinite loop" do
    {:ok, m} = Advent8.run_corrupted_program(stream_of(@loop_example_program))
    assert m.acc == 8
  end
end
