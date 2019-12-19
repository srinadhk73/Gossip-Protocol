defmodule PushSum do

    use GenServer

    def start_link(selfID, neighborList) when is_integer(selfID) do
        GenServer.start_link(__MODULE__, [selfID, neighborList], name: register_node(selfID))
    end



    defp register_node(selfID), do: {:via, Registry, {:n_directory, selfID}}

    def init([selfID, neighborList]) do
        receive do
            {_, sumPS, weight} -> rumoringProcess = Task.start fn -> pushsumTask(selfID,neighborList,sumPS+selfID,weight+1) end
                                pushsumListner(1, sumPS+selfID, weight+1, selfID, rumoringProcess, selfID)
        end
        {:ok, selfID}
    end



    def pushsumListner(count, sumPS, weight, oldRatio, rumoringProcess, selfID) do
        newRatio = sumPS/weight
        diff = abs(newRatio - oldRatio)
        count = if diff > :math.pow(10,-10) do
                    0
                else
                    count + 1
                end
        if count >= 3 do
            IO.puts "The node #{selfID} has converged"
            send(:global.whereis_name(:listner),{:converged, self()})
            Task.shutdown(rumoringProcess, :brutal_kill)
        else
            sumPS = sumPS/2
            weight = weight/2
            send(elem(rumoringProcess,1),{:chinesewhisper, sumPS, weight})
            receive do
                {:chinesewhisper, recSum, recWeight} -> pushsumListner(count, recSum+sumPS, recWeight+weight, newRatio, rumoringProcess, selfID)
            after
                100 -> pushsumListner(count, sumPS, weight, newRatio, rumoringProcess, selfID)
            end
        end
    end

################

    def pushsumTask(selfID,neighborList,sumPS,weight) do
        {sumPS, weight} = receive do
                            {:chinesewhisper, recSum, recWeight} -> {recSum, recWeight}
                          end
        index = :rand.uniform(length(neighborList))-1
        selected_node = Enum.at(neighborList, index)
	    case selected_node do
		    selfID -> if index == length(neighborList)-1 do
			  	        index - 1
			          else
				        index + 1
			          end
			          selected_node = Enum.at(neighborList,index)
		        _ -> nil
	    end
        sel_node_addr = whereis(selected_node)
        if sel_node_addr != nil do
            send(sel_node_addr,{:chinesewhisper, sumPS, weight})
        end
        pushsumTask(selfID,neighborList,sumPS,weight)
    end

#######

    def whereis(thisNode) do
        case Registry.lookup(:n_directory, thisNode) do
            [{pid, _}] -> pid
            [] -> nil
        end
    end
end
