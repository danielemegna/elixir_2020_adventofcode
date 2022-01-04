defmodule Advent17 do
  
  def resolve_first_part do
    read_input_file_content()
    |> parse_inital_configuration()
    |> active_after(6)
  end

  def active_after(initial_configuration, cycles) do
    1..cycles
    |> Enum.reduce(initial_configuration, fn _, active_cubes ->
      execute_cycle(active_cubes)
    end)
    |> Enum.count
  end

  def active_neighbors(active_cubes, coordinate) do
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
      active_neighbors = active_neighbors(active_cubes, current)
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
    # TODO: generate this ?

    [
      {x,y-1,z},
      {x-1,y-1,z},
      {x+1,y-1,z},

      {x,y+1,z},
      {x+1,y+1,z},
      {x-1,y+1,z},

      {x-1,y,z},
      {x+1,y,z},

      # --------

      {x,y-1,z+1},
      {x-1,y-1,z+1},
      {x+1,y-1,z+1},

      {x,y+1,z+1},
      {x+1,y+1,z+1},
      {x-1,y+1,z+1},

      {x-1,y,z+1},
      {x,y,z+1},
      {x+1,y,z+1},

      # --------

      {x,y-1,z-1},
      {x-1,y-1,z-1},
      {x+1,y-1,z-1},

      {x,y+1,z-1},
      {x+1,y+1,z-1},
      {x-1,y+1,z-1},

      {x-1,y,z-1},
      {x,y,z-1},
      {x+1,y,z-1},
    ]
  end

  defp read_input_file_content do
    File.stream!("advent17.txt")
    |> Stream.map(&String.trim/1)
  end

end
