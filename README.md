# Elixir Advent of Code 2020

Solutions for https://adventofcode.com/2020 in elixir-lang (https://elixir-lang.org/)

## Run

Get dependencies and run tests with
```
$ mix deps.get
$ mix test
```

Challenge solutions are in tests as assertions:

```elixir
defmodule Advent1Test do
  use ExUnit.Case

  test "resolve level" do
    assert Advent1.resolve == 181044
  end

end

```

To use temporary dev docker container

```
$ docker run --rm -itv $PWD:/app -w /app elixir:alpine sh
# mix deps.get
# mix test
```

or just run tests

```
$ docker run --rm -itv $PWD:/app -w /app elixir:alpine mix test
```
