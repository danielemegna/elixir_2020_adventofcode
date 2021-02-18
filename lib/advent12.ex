defmodule Waypoint do
  @enforce_keys [:position]
  defstruct @enforce_keys

  def new() do
    %Waypoint{position: %{x: 10, y: 1}}
  end

  def move_by(%Waypoint{} = waypoint, instruction) do
    {command, steps} = String.split_at(instruction, 1)
    steps = String.to_integer(steps)
    case command do
      "N" -> move_north(waypoint, steps)
      "S" -> move_south(waypoint, steps)
      "W" -> move_west(waypoint, steps)
      "E" -> move_east(waypoint, steps)
      "L" -> rotate_left(waypoint, steps)
      "R" -> rotate_right(waypoint, steps)
      "F" -> raise ArgumentError, message: "Waypoint do not support forward instructions"
    end
  end

  defp move_north(waypoint, steps), do: put_in(waypoint.position.y, waypoint.position.y + steps)
  defp move_south(waypoint, steps), do: put_in(waypoint.position.y, waypoint.position.y - steps)
  defp move_west(waypoint, steps), do: put_in(waypoint.position.x, waypoint.position.x - steps)
  defp move_east(waypoint, steps), do: put_in(waypoint.position.x, waypoint.position.x + steps)

  defp rotate_left(waypoint, 0), do: waypoint
  defp rotate_left(waypoint, degrees) do
    rotated_left_by_90 = %Waypoint{waypoint | position: %{x: -waypoint.position.y, y: waypoint.position.x}}
    rotate_left(rotated_left_by_90, degrees-90)
  end

  defp rotate_right(waypoint, 0), do: waypoint
  defp rotate_right(waypoint, degrees) do
    rotated_right_by_90 = %Waypoint{waypoint | position: %{ x: waypoint.position.y, y: -waypoint.position.x}}
    rotate_right(rotated_right_by_90, degrees-90)
  end
end

######################################################

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

  def move_by(%Ship{} = ship, instruction, %Waypoint{} = waypoint) do
    {_command, steps} = String.split_at(instruction, 1)
    steps = String.to_integer(steps)
    %Ship{ship | position: %{
      x: ship.position.x + (waypoint.position.x * steps),
      y: ship.position.y + (waypoint.position.y * steps)
    }}
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
