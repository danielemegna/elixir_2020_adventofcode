defmodule NavigationInstruction do
  @enforce_keys [:operation, :quantity]
  defstruct @enforce_keys

  def parse(instruction_string) do
    {operation_string, quantity_string} = String.split_at(instruction_string, 1)

    operation = case operation_string do
      "N" -> :move_north
      "S" -> :move_south
      "W" -> :move_west
      "E" -> :move_east
      "F" -> :move_forward
      "L" -> :rotate_left
      "R" -> :rotate_right
    end
    quantity = String.to_integer(quantity_string)

    %NavigationInstruction{operation: operation, quantity: quantity}
  end
end

######################################################

defmodule Waypoint do
  @enforce_keys [:position]
  defstruct @enforce_keys

  def new() do
    %Waypoint{position: %{x: 10, y: 1}}
  end

  def move_by(%Waypoint{} = waypoint, instruction_string) when is_binary(instruction_string), do:
    move_by(waypoint, NavigationInstruction.parse(instruction_string))

  def move_by(%Waypoint{} = waypoint, %NavigationInstruction{} = instruction) do
    case instruction.operation do
      :move_north -> move_north(waypoint, instruction.quantity)
      :move_south -> move_south(waypoint, instruction.quantity)
      :move_west -> move_west(waypoint, instruction.quantity)
      :move_east -> move_east(waypoint, instruction.quantity)
      :rotate_left -> rotate_left(waypoint, instruction.quantity)
      :rotate_right -> rotate_right(waypoint, instruction.quantity)
      :move_forward -> waypoint # waypoint position is always related to the ship
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

  def new(), do: %Ship{orientation: :east, position: %{x: 0, y: 0}}

  def manhattan_distance_from_center(%Ship{} = ship), do:
    abs(ship.position.x) + abs(ship.position.y)

  def move_by(%Ship{} = ship, instruction_string) when is_binary(instruction_string), do:
    move_by(ship, NavigationInstruction.parse(instruction_string))

  def move_by(%Ship{} = ship, %NavigationInstruction{} = instruction) do
    case instruction.operation do
      :move_north -> move_north(ship, instruction.quantity)
      :move_south -> move_south(ship, instruction.quantity)
      :move_west -> move_west(ship, instruction.quantity)
      :move_east -> move_east(ship, instruction.quantity)
      :move_forward -> move_forward(ship, instruction.quantity)
      :rotate_left -> rotate_left(ship, instruction.quantity)
      :rotate_right -> rotate_right(ship, instruction.quantity)
    end
  end

  def move_by(%Ship{} = ship, instruction_string, %Waypoint{} = waypoint) when is_binary(instruction_string), do:
    move_by(ship, NavigationInstruction.parse(instruction_string), waypoint)

  def move_by(
    %Ship{} = ship,
    %NavigationInstruction{operation: :move_forward, quantity: steps},
    %Waypoint{} = waypoint
  ) do
    %Ship{ship | position: %{
      x: ship.position.x + (waypoint.position.x * steps),
      y: ship.position.y + (waypoint.position.y * steps)
    }}
  end

  # other navigation instructions using waypoint should be ignored
  def move_by(%Ship{} = ship, %NavigationInstruction{}, %Waypoint{}), do: ship

  defp move_north(ship, steps), do: put_in(ship.position.y, ship.position.y + steps)
  defp move_south(ship, steps), do: put_in(ship.position.y, ship.position.y - steps)
  defp move_west(ship, steps), do: put_in(ship.position.x, ship.position.x - steps)
  defp move_east(ship, steps), do: put_in(ship.position.x, ship.position.x + steps)

  defp move_forward(ship, steps) do
    case ship.orientation do
      :north -> move_north(ship, steps)
      :south -> move_south(ship, steps)
      :west -> move_west(ship, steps)
      :east -> move_east(ship, steps)
    end
  end

  defp rotate_left(ship, 0), do: ship
  defp rotate_left(ship, degrees) do
    new_orientation = case ship.orientation do
      :north -> :west 
      :west -> :south
      :south -> :east
      :east -> :north
    end
    rotated_left_by_90 = put_in(ship.orientation, new_orientation)
    rotate_left(rotated_left_by_90, degrees-90)
  end

  defp rotate_right(ship, 0), do: ship
  defp rotate_right(ship, degrees) do
    new_orientation = case ship.orientation do
      :north -> :east 
      :east -> :south
      :south -> :west
      :west -> :north
    end
    rotated_right_by_90 = put_in(ship.orientation, new_orientation)
    rotate_right(rotated_right_by_90, degrees-90)
  end
end

######################################################

defmodule Advent12 do

  def resolve_first_part() do
    read_navigation_instructions_stream()
    |> apply_on_new_ship()
    |> Ship.manhattan_distance_from_center()
  end

  def resolve_second_part() do
    read_navigation_instructions_stream()
    |> apply_on_new_ship_with_waypoint()
    |> Ship.manhattan_distance_from_center()
  end

  def apply_on_new_ship(instructions_stream) do
    instructions_stream
    |> Stream.map(&NavigationInstruction.parse/1)
    |> Enum.reduce(Ship.new(), fn instruction, ship ->
      Ship.move_by(ship, instruction)
    end)
  end

  def apply_on_new_ship_with_waypoint(instructions_stream) do
    instructions_stream
    |> Stream.map(&NavigationInstruction.parse/1)
    |> Enum.reduce({Ship.new(), Waypoint.new()}, fn instruction, {ship, waypoint} ->
      {
        Ship.move_by(ship, instruction, waypoint),
        Waypoint.move_by(waypoint, instruction)
      }
    end)
    |> elem(0)
  end

  defp read_navigation_instructions_stream() do
    File.stream!("advent12.txt")
    |> Stream.map(&String.trim/1)
  end

end
