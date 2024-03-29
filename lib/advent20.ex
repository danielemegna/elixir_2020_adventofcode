defmodule Tile do
  @enforce_keys [:id, :border_top, :border_left, :border_bottom, :border_right, :content]
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
        content: image_lines
          |> Enum.slice(1..-2)
          |> Enum.map(&(String.slice(&1, 1..-2)))
      }
  end

  def compatible_with(tile, border) do
    reversed_border = String.reverse(border)
    tile.border_top == border || tile.border_top == reversed_border ||
      tile.border_left == border || tile.border_left == reversed_border ||
      tile.border_bottom == border || tile.border_bottom == reversed_border ||
      tile.border_right == border || tile.border_right == reversed_border
  end
end

########################################

defmodule Advent20 do

  def resolve_first_part do
    read_input_file_content()
    |> parse_input_file()
    |> four_corner_check()
  end

  def four_corner_check(tiles) do
    tiles
    |> Enum.map(&(compatibility_map(&1, tiles)))
    |> Enum.filter(fn m ->
      Map.values(m) |> Enum.filter(&(&1 == :none)) |> Enum.count == 2
    end)
    |> Enum.map(&(Map.get(&1, :id)))
    |> Enum.product()
  end

  def compatibility_map(tile, tiles) do
    tiles = Enum.reject(tiles, &(&1.id == tile.id))

    id_or_none = fn
      nil -> :none
      %Tile{} = t -> t.id
    end

    %{
      id: tile.id,
      top: tiles |> Enum.find(&(Tile.compatible_with(&1, tile.border_top))) |> id_or_none.(),
      left: tiles |> Enum.find(&(Tile.compatible_with(&1, tile.border_left))) |> id_or_none.(),
      bottom: tiles |> Enum.find(&(Tile.compatible_with(&1, tile.border_bottom))) |> id_or_none.(),
      right: tiles |> Enum.find(&(Tile.compatible_with(&1, tile.border_right))) |> id_or_none.()
    }
  end

  def parse_input_file(lines) do
    lines
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(&Tile.from/1)
  end

  defp read_input_file_content do
    File.stream!("advent20.txt")
    |> Stream.map(&String.trim/1)
  end

end
