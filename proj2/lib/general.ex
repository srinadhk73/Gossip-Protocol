defmodule General do
  def gossipfunc(noOfNodes) do
    listner = Task.async(fn -> GossipActors.converged(noOfNodes) end)
    :global.register_name(:listner, listner.pid)
    :global.register_name(:server, self())
    start_time = System.system_time(:millisecond)
    IO.puts "Start gossip at #{start_time} milliseconds"
    GossipActors.doGossiping(noOfNodes)
    GossipActors.nodeKill(noOfNodes)
    Task.await(listner, :infinity)
    stop_time = System.system_time(:millisecond)
    IO.puts "Network converged at #{stop_time} milliseconds"
    time_diff = stop_time - start_time
    IO.puts "Time taken to achieve convergence is #{time_diff} milliseconds"
  end

  def pushfunc(noOfNodes) do
    listner = Task.async(fn -> PushSumActors.converged(noOfNodes) end)
    :global.register_name(:listner, listner.pid)
    :global.register_name(:server, self())
    start_time = System.system_time(:millisecond)
    IO.puts "Start pushsum at #{start_time} milliseconds"
    PushSumActors.pushSum(noOfNodes)
    PushSumActors.nodeKill(noOfNodes)
    Task.await(listner, :infinity)
    stop_time = System.system_time(:millisecond)
    IO.puts "Network converged at #{stop_time} milliseconds"
    time_diff = stop_time - start_time
    IO.puts "Time taken to achieve convergence is #{time_diff} milliseconds"
  end
end
