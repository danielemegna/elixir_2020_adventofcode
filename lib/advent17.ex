defmodule Advent17 do
  
  def resolve_first_part do
    read_input_file_content()
    |> parse_inital_configuration()
    |> active_after(6)
  end

  def resolve_second_part do
    read_input_file_content()
    |> parse_inital_configuration()
    |> add_fourth_dimension()
    |> active_after(6)
  end

  def active_after(initial_configuration, cycles) do
    1..cycles
    |> Enum.reduce(initial_configuration, fn _, active_cubes ->
      execute_cycle(active_cubes)
    end)
    |> Enum.count
  end

  def active_neighbors_of(active_cubes, coordinate) do
    neighbors_coordinates = neighbors_coordinates_of(coordinate)
    (active_cubes -- (active_cubes -- neighbors_coordinates))
    |> Enum.count
  end

  def parse_inital_configuration(lines) do
    lines
    |> Enum.with_index
    |> Enum.flat_map(fn {line, y} ->
      String.graphemes(line)
      |> Enum.with_index
      |> Enum.map(fn {symbol, x} ->
        case symbol do
          "#" -> {x,y,0}
          _ -> nil
        end
      end)
      |> Enum.reject(&is_nil/1)
    end)
  end

  def execute_cycle(active_cubes) do
    active_cubes
    |> Enum.reduce(MapSet.new(), fn coordinate, acc ->
      MapSet.union(acc, MapSet.new(neighbors_coordinates_of(coordinate)))
    end)
    |> parallel_map(fn current ->
      was_active? = Enum.member?(active_cubes, current)
      active_neighbors = active_neighbors_of(active_cubes, current)
      case next_state(was_active?, active_neighbors) do
        :active -> current
        :inactive -> nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp parallel_map(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  defp next_state(true, active_neighbors) when active_neighbors in [2,3], do: :active
  defp next_state(false, 3), do: :active
  defp next_state(_, _), do: :inactive

  defp neighbors_coordinates_of({x,y,z}) do
    [x-1, x, x+1]
    |> Enum.flat_map(fn x ->
      [y-1, y, y+1]
      |> Enum.flat_map(fn y ->
        [z-1, z, z+1]
        |> Enum.map(fn z ->
          {x,y,z}
        end)
      end)
    end)
    |> Enum.reject(&(&1 == {x,y,z}))
  end

  defp neighbors_coordinates_of({x,y,z,w}) do
    [x-1, x, x+1]
    |> Enum.flat_map(fn x ->
      [y-1, y, y+1]
      |> Enum.flat_map(fn y ->
        [z-1, z, z+1]
        |> Enum.flat_map(fn z ->
          [w-1, w, w+1]
          |> Enum.map(fn w ->
            {x,y,z,w}
          end)
        end)
      end)
    end)
    |> Enum.reject(&(&1 == {x,y,z,w}))
  end

  defp add_fourth_dimension(active_cubes) do
    active_cubes |> Enum.map(&(Tuple.append(&1, 0)))
  end

  defp read_input_file_content do
    File.stream!("advent17.txt")
    |> Stream.map(&String.trim/1)
  end

end
