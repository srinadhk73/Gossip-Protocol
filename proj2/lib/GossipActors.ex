defmodule GossipActors do

    def createActors(noOfNodes, topology, algo) do
          if topology == "full" do
                #Nlist = Enum.to_list 1..noOfNodes
                neighbor = Enum.to_list 1..noOfNodes
                for i <- 1..noOfNodes do
                #    neighbor = List.delete_at(NList,i)
                    pid = spawn(fn -> Gossip.start_link(i,neighbor) end)
                    Process.monitor(pid)
                end
                General.gossipfunc(noOfNodes)
            end

            if topology == "rand2D" do
                :ets.new(:node_table,[:set, :public, :named_table])
				for i <- 1..noOfNodes do
					:ets.insert(:node_table, {i,:rand.uniform,:rand.uniform})
				end
				for i <- 1..noOfNodes do
				neighbor = neighborSelection(noOfNodes,i,1,[])
					pid = spawn(fn -> Gossip.start_link(i, neighbor) end)
					Process.monitor(pid)
				end
			General.gossipfunc(noOfNodes)
            end


                        if topology == "3Dtorus" do
                            :ets.new(:node_table,[:set, :public, :named_table])
            				for i <- 1..noOfNodes do
            					:ets.insert(:node_table, {i})
            				end
            				for i <- 1..noOfNodes do
            				neighbor = Torus.getNeighbours(i,noOfNodes)
            					pid = spawn(fn -> Gossip.start_link(i, neighbor) end)
            					Process.monitor(pid)
            				end

            				General.gossipfunc(noOfNodes)
                  end


                       if topology == "honeycomb" do
                    #         :ets.new(:node_table,[:set, :public, :named_table])
                    # for i <- 1..noOfNodes do
                    #   :ets.insert(:node_table, {i})
                    # end
                    for i <- 1..noOfNodes do
                    neighbor = Honeycomb.getNeighbours(i,noOfNodes)
                      pid = spawn(fn -> Gossip.start_link(i, neighbor) end)
                      Process.monitor(pid)
                    end
                  General.gossipfunc(noOfNodes)
                    # :ets.delete(:node_table)
                        end

                                               if topology == "randhoneycomb" do
                                            #         :ets.new(:node_table,[:set, :public, :named_table])
                                            # for i <- 1..noOfNodes do
                                            #   :ets.insert(:node_table, {i})
                                            # end
                                            for i <- 1..noOfNodes do
                                            neighbor = Honeycomb.getRandNeighbours(i,noOfNodes)
                                              pid = spawn(fn -> Gossip.start_link(i, neighbor) end)
                                              Process.monitor(pid)
                                            end
                                            General.gossipfunc(noOfNodes)  end



      if topology == "line" do
				for i <- 1..noOfNodes do
					neighbor = cond do
								i == 1 ->  [i+1]
								i == noOfNodes -> [i-1]
								true -> [i-1,i+1]
							end
					pid = spawn(fn -> Gossip.start_link(i,neighbor) end)
					Process.monitor(pid)
				end
				General.gossipfunc(noOfNodes)
			end

    end

    def neighborSelection(noOfNodes, nodeID, count, list) when count >= noOfNodes do
		selfcordinates = :ets.match(:node_table, {nodeID, :"$1", :"$2"})
		[val|tail] = selfcordinates
		[x|rem] = val
		[y|un] = rem
	 	neighcordinates = :ets.match(:node_table, {count, :"$1", :"$2"})
		[val1|tail1] = neighcordinates
		[xs|rem1] = val1
		[ys|un1] = rem1
		firstTerm = :math.pow((x-xs),2)
		secTerm = :math.pow((y-ys),2)
		distance = :math.sqrt(firstTerm+secTerm)
		list = if distance < 0.1 and distance != 0.0 do [count | list] else list
		end
	end


	def neighborSelection(noOfNodes, nodeID, count, list) do
		selfcordinates = :ets.match(:node_table, {nodeID, :"$1", :"$2"})
		[val|tail] = selfcordinates
		[x|rem] = val
		[y|un] = rem
	 	neighcordinates = :ets.match(:node_table, {count, :"$1", :"$2"})
		[val1|tail1] = neighcordinates
		[xs|rem1] = val1
		[ys|un1] = rem1
		firstTerm = :math.pow((x-xs),2)
		secTerm = :math.pow((y-ys),2)
		distance = :math.sqrt(firstTerm+secTerm)
		list = if distance < 0.1 and distance != 0.0 do [count | list] else list
		end
		neighborSelection(noOfNodes, nodeID, count+1, list)
	end



    def doGossiping(noOfNodes) do
        pick_node = :rand.uniform(noOfNodes)
    #    node_pid = Server.whereis(pick_node)
          case Registry.lookup(:n_directory, pick_node) do
            [{pid,_}] ->  send(pid, {:listner, "Superman and Spiderman are enemies"})
            [] -> doGossiping(noOfNodes)
          end

    end



    def nodeKill(noOfNodes) do
        if noOfNodes != 0 do
            receive do
                {:DOWN, _, :process, _pid, _reason} -> nodeKill(noOfNodes-1)
            end
        else
            nil
        end
    end



    def converged(noOfNodes) do
        if(noOfNodes != 0) do
            receive do
                {:converged, _} -> converged(noOfNodes-1)
            after
                5000 -> send(:global.whereis_name(:server),{:DOWN, :anything, :process, :random, :getreadytonodeKill})
                        converged(noOfNodes-1)
            end
        end
    end



end
