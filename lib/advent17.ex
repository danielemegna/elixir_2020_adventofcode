defmodule Advent17 do

  def active_neighbors(active_cubes, coordinate) do
    neighbors_coordinates = neighbors_coordinates_of(coordinate)
    (active_cubes -- (active_cubes -- neighbors_coordinates))
    |> Enum.count
  end

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

end
