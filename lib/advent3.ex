defmodule TreesMap do
  @enforce_keys [:lines, :width, :height]
  defstruct @enforce_keys

  def from(map_string) when is_binary(map_string) do
    map_string
    |> String.split("\n", trim: true)
    |> __MODULE__.from()
  end

  def from(lines) do
    width = lines |> Enum.at(0) |> String.length
    height = lines |> Enum.count
    %__MODULE__{lines: lines, width: width, height: height}
  end

  def at(map, {x, y}) do
    map.lines
    |> Enum.at(y)
    |> String.at(rem(x, map.width))
    |> case do
      "." -> :empty
      "#" -> :tree
    end
  end
end

defmodule Advent3 do

  def resolve_first_part do
    read_trees_map_from_file()
    |> TreesMap.from()
    |> count_trees_for({3, 1})
  end

  def count_trees_for(map_string, slope) when is_binary(map_string) do
    TreesMap.from(map_string)
    |> count_trees_for(slope)
  end

  def count_trees_for(%TreesMap{} = map, slope) do
    count_trees_for(map, slope, {0, 0}, 0)
  end

  defp count_trees_for(%TreesMap{} = map, {right, down} = slope, {x, y} = _position, encountered_trees) do
    encountered_trees = 
      TreesMap.at(map, {x, y})
      |> case do
        :empty -> encountered_trees
        :tree -> encountered_trees+1
      end

    new_x = x + right
    new_y = y + down

    if new_y >= map.height,
      do: encountered_trees,
      else: count_trees_for(map, slope, {new_x, new_y}, encountered_trees)
  end

  defp read_trees_map_from_file do
    File.stream!("advent3.txt")
    |> Stream.map(&String.trim/1)
  end

end
