defmodule Server do
  def main(args) do
  if List.first(args) == "" do
      IO.puts "Please enter the arguments"
    else
    noOfNodes = args |> Enum.at(0) |> String.to_integer
    topology = args |> Enum.at(1)
    algo = args |> Enum.at(2)
      Registry.start_link(keys: :unique, name: :n_directory)
          if algo == "gossip" do
        GossipActors.createActors(noOfNodes, topology, algo)
        end
          if algo == "pushsum" do
      PushSumActors.createActors(noOfNodes, topology, algo)
          end
    end

  end
  end
