defmodule Advent17 do

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
    {xs,ys,zs} = active_cubes
    |> Enum.reduce({[],[],[]}, fn {x,y,z}, {xs,ys,zs} ->
      { [x | xs], [y | ys], [z | zs] }
    end)

    (Enum.min(xs)-1)..(Enum.max(xs)+1)
    |> Enum.flat_map(fn x ->
      (Enum.min(ys)-1)..(Enum.max(ys)+1)
      |> Enum.flat_map(fn y ->
        (Enum.min(zs)-1)..(Enum.max(zs)+1)
        |> Enum.map(fn z ->
          current = {x,y,z}
          was_active? = Enum.member?(active_cubes, current)
          active_neighbors = active_neighbors(active_cubes, current)
          case next_state(was_active?, active_neighbors) do
            :active -> current
            :inactive -> nil
          end
        end)
      end)
    end)
    |> Enum.reject(&is_nil/1)
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

end
