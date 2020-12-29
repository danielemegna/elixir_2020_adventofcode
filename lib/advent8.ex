defmodule Machine do
  defstruct [pointer: 0, acc: 0]

  def run(%Machine{} = m, instructions) when is_list(instructions) do
    i = Enum.at(instructions, m.pointer)
    m = run(m, i)

    if should_halt(m, instructions), do: m,
    else: run(m, instructions)
  end

  def run(%Machine{} = m, {:acc, v}), do:
    %{m | acc: m.acc+v, pointer: m.pointer+1}

  def run(%Machine{} = m, {:jmp, v}), do:
    %{m | pointer: m.pointer+v}
  
  def run(%Machine{} = m, {:nop, _}), do:
    %{m | pointer: m.pointer+1}

  defp should_halt(%Machine{} = m, instructions) do
    m.pointer < 0 || m.pointer >= Enum.count(instructions)
  end

end

defmodule Advent8 do

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

end
