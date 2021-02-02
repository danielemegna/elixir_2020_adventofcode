defmodule Ship do
  @enforce_keys [:direction, :position]
  defstruct @enforce_keys

  def new(direction \\ :east) do
    %Ship{direction: direction, position: %{x: 0, y: 0}}
  end

  def move_by(ship, instruction) do
    {command, steps} = String.split_at(instruction, 1)
    steps = String.to_integer(steps)
    case command do
      "N" -> move_north(ship, steps)
      "S" -> move_south(ship, steps)
      "W" -> move_west(ship, steps)
      "E" -> move_east(ship, steps)
      "F" -> move_forward(ship, steps)
      "L" -> rotate_left(ship, steps)
    end
  end

  defp move_forward(%Ship{direction: :east} = ship, steps), do: move_east(ship, steps)
  defp move_forward(%Ship{direction: :north} = ship, steps), do: move_north(ship, steps)
  defp move_forward(%Ship{direction: :south} = ship, steps), do: move_south(ship, steps)

  defp move_north(ship, steps), do: put_in(ship.position.y, ship.position.y + steps)
  defp move_south(ship, steps), do: put_in(ship.position.y, ship.position.y - steps)
  defp move_west(ship, steps), do: put_in(ship.position.x, ship.position.x - steps)
  defp move_east(ship, steps), do: put_in(ship.position.x, ship.position.x + steps)

  defp rotate_left(ship, degrees) do
    directions = [:north, :west, :south, :east]
    steps = trunc(degrees / 90)
    current_direction_index = Enum.find_index(directions, &(&1 == ship.direction))

    new_direction = Enum.at(directions, Integer.mod(current_direction_index + steps, 4))

    put_in(ship.direction, new_direction)
  end
end

defmodule Advent12 do

  #defp read_file() do
  #  File.stream!("advent12.txt")
  #  |> Stream.map(&String.trim/1)
  #end

end
