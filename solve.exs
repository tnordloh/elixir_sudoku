Code.load_file("sudoku.exs", __DIR__)

IO.inspect System.argv
{:ok, file} = File.read hd(System.argv)

IO.puts(file)
sudoku_map = [Sudoku.to_board(file) |> Sudoku.to_map]

defmodule Solver do
  def solve([first_map|other_maps]) do
    IO.puts("solving...")
    if Sudoku.invalid?(first_map) do
      solve(other_maps)
    else
      solutions = Sudoku.fill_cell(first_map)
      if Sudoku.unsolved?(hd(solutions)) do
        IO.puts Sudoku.to_s(hd(solutions))
        solve(solutions ++ other_maps)
      else
        solve(hd(solutions), true)
      end
    end
  end
  def solve(list, _solved) do
    IO.puts "solution found" 
    IO.puts Sudoku.to_s(list)
  end
end

Solver.solve(sudoku_map)
