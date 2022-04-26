defmodule Tile do
  @enforce_keys [:id, :border_top, :border_left, :border_bottom, :border_right]
  defstruct @enforce_keys

  def from(tile_lines) do
      [id_line | image_lines] = tile_lines
      %Tile{
        id: id_line
          |> String.split(" ")
          |> Enum.at(1)
          |> Integer.parse()
          |> elem(0),
        border_top: Enum.at(image_lines, 0), 
        border_left: image_lines
          |> Enum.map(&(String.at(&1, 0)))
          |> Enum.join(),
        border_bottom: Enum.at(image_lines, 9),
        border_right: image_lines
          |> Enum.map(&(String.at(&1, 9)))
          |> Enum.join(),
      }
  end
end

defmodule Advent20 do

  def parse_input_file(lines) do
    lines
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(&Tile.from/1)
  end

end
