defmodule Gossip do

    use GenServer

    def start_link(selfID, neighborList) when is_integer(selfID) do
        GenServer.start_link(__MODULE__, [selfID, neighborList], name: register_node(selfID))
    end


    defp register_node(selfID), do: {:via, Registry, {:n_directory, selfID}}

    def init([selfID, neighborList]) do
            receive do
                {_, rumor} -> rumoringProcess = Task.start fn -> gossiper(selfID,neighborList,rumor) end
                              gossipListner(1, rumoringProcess, selfID)
            end
            {:ok, selfID}

end


    def gossipListner(count, rumoringProcess, selfID) do
        if(count < 10) do
            receive do
                {:whisper, rumor} -> gossipListner(count+1, rumoringProcess, selfID)
            end
        else
            IO.puts "Node #{selfID} has converged"
            send(:global.whereis_name(:listner), {:converged, self()})
            Task.shutdown(rumoringProcess, :brutal_kill)
        end
    end


    def gossiper(selfID,neighborList,rumor) do
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

      sel_node_addr =   case Registry.lookup(:n_directory, selected_node) do
            [{pid, _}] -> pid
            [] -> nil
        end
        if sel_node_addr != nil do
            send(sel_node_addr,{:whisper, rumor})
        end
        Process.sleep(55)
        gossiper(selfID,neighborList,rumor)
    end



end
