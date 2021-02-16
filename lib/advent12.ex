defmodule Ship do
  @enforce_keys [:orientation, :position]
  defstruct @enforce_keys

  def new() do
    %Ship{orientation: :east, position: %{x: 0, y: 0}}
  end

  def move_by(%Ship{} = ship, instruction) do
    {command, steps} = String.split_at(instruction, 1)
    steps = String.to_integer(steps)
    case command do
      "N" -> move_north(ship, steps)
      "S" -> move_south(ship, steps)
      "W" -> move_west(ship, steps)
      "E" -> move_east(ship, steps)
      "F" -> move_forward(ship, steps)
      "L" -> rotate_left(ship, steps)
      "R" -> rotate_right(ship, steps)
    end
  end

  def manhattan_distance_from_center(%Ship{} = ship), do:
    abs(ship.position.x) + abs(ship.position.y)

  defp move_forward(%Ship{orientation: :north} = ship, steps), do: move_north(ship, steps)
  defp move_forward(%Ship{orientation: :south} = ship, steps), do: move_south(ship, steps)
  defp move_forward(%Ship{orientation: :west} = ship, steps), do: move_west(ship, steps)
  defp move_forward(%Ship{orientation: :east} = ship, steps), do: move_east(ship, steps)

  defp move_north(ship, steps), do: put_in(ship.position.y, ship.position.y + steps)
  defp move_south(ship, steps), do: put_in(ship.position.y, ship.position.y - steps)
  defp move_west(ship, steps), do: put_in(ship.position.x, ship.position.x - steps)
  defp move_east(ship, steps), do: put_in(ship.position.x, ship.position.x + steps)

  defp rotate_left(ship, degrees), do: rotate(ship, degrees, [:north, :west, :south, :east])
  defp rotate_right(ship, degrees), do: rotate(ship, degrees, [:north, :east, :south, :west])

  defp rotate(ship, degrees, orientation_rotation_order) do
    steps = trunc(degrees / 90)
    current_orientation_index = orientation_rotation_order |> Enum.find_index(&(&1 == ship.orientation))
    new_orientation_index = Integer.mod(current_orientation_index + steps, 4)
    new_orientation = Enum.at(orientation_rotation_order, new_orientation_index)
    put_in(ship.orientation, new_orientation)
  end
end

######################################################

defmodule Advent12 do

  def resolve_first_part() do
    read_ship_commands_stream()
    |> apply_on_new_ship()
    |> Ship.manhattan_distance_from_center()
  end

  def apply_on_new_ship(commands_stream) do
    commands_stream
    |> Enum.reduce(Ship.new(), fn command, ship ->
      Ship.move_by(ship, command)
    end)
  end

  defp read_ship_commands_stream() do
    File.stream!("advent12.txt")
    |> Stream.map(&String.trim/1)
  end

end
