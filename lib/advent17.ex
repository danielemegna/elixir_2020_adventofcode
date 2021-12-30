defmodule Advent17 do

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
