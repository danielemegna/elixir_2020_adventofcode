defmodule Machine do
  defstruct [pointer: 0, acc: 0, history: []]

  def run(%Machine{} = m, instructions) when is_list(instructions) do
    i = Enum.at(instructions, m.pointer)
    m = run(m, i) |> Map.put(:history, [m.pointer | m.history])

    cond do
      should_halt?(m, instructions) -> {:ok, m}
      wrong_pointer?(m, instructions) -> {:wrong_pointer, m}
      loop_recongized?(m) -> {:loop, m}
      true -> run(m, instructions)
    end
  end

  def run(%Machine{} = m, {:acc, v}), do:
    %{m | acc: m.acc+v, pointer: m.pointer+1}

  def run(%Machine{} = m, {:jmp, v}), do:
    %{m | pointer: m.pointer+v}
  
  def run(%Machine{} = m, {:nop, _}), do:
    %{m | pointer: m.pointer+1}

  defp should_halt?(%Machine{} = m, instructions) do
    m.pointer == Enum.count(instructions)
  end

  defp wrong_pointer?(%Machine{} = m, instructions) do
    m.pointer < 0 || m.pointer >= Enum.count(instructions)
  end

  defp loop_recongized?(%Machine{} = m) do
    m.pointer in m.history
  end

end

defmodule Advent8 do

  def resolve_first_part() do
    {:loop, machine} = read_boot_code_file()
    |> run_on_machine()

    machine.acc
  end

  def resolve_second_part() do
    {:ok, machine} = read_boot_code_file()
    |> run_corrupted_program()

    machine.acc
  end

  def run_corrupted_program(instructions_stream) do
    instructions = parse_instructions(instructions_stream)

    instructions
    |> Stream.with_index
    |> Stream.filter(fn {{op,_v},_index} -> op in [:nop, :jmp] end)
    |> Stream.map(fn {_,op_index} -> op_index end)
    |> Stream.map(fn op_index ->
      instructions |> List.update_at(op_index, fn
        {:nop, v} -> {:jmp, v}
        {:jmp, v} -> {:nop, v}
      end)
    end)
    |> Stream.map(&(Machine.run(%Machine{}, &1)))
    |> Enum.find(&(match?({:ok, _}, &1)))
  end

  def run_on_machine(instructions_stream) do
    instructions = parse_instructions(instructions_stream)
    %Machine{} |> Machine.run(instructions)
  end
  
  def parse_instructions(stream) do
    Enum.map(stream, fn line ->
      [op, val] = String.split(line)
      {String.to_atom(op), String.to_integer(val)}
    end)
  end

  defp read_boot_code_file do
    File.stream!("advent8.txt")
    |> Stream.map(&String.trim/1)
  end

end
