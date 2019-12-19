defmodule Honeycomb do
  def getNeighbours(i,numNodes) do
      numNodes = if(:math.sqrt(numNodes) == round(:math.sqrt(numNodes))) do
          numNodes
      else
          i=round(:math.ceil(:math.sqrt(numNodes)))
          i*i
      end

      rows = round(:math.sqrt(numNodes))
      firstRow = Enum.to_list(1..rows)
      lastRow = Enum.to_list(((rows*rows)-rows+1)..rows*rows)

      firstRow = Enum.map(firstRow,fn(k)->
        adjNodes = cond do
          k==1    -> [k+1,k+rows]
          k==rows -> if rem(k,2) == 0 do
                        [k-1]
                      else
                        [k-1,k+rows]
                      end
          true    ->  if rem(k,2) == 0 do
                        [k-1,k+1]
                      else
                        [k-1,k+1,k+rows]
                      end
        end
        adjNodes
      end)


      middleRows = Enum.to_list(rows+1..((rows*rows)-rows))
      middleRows = Enum.map(middleRows,fn(k)->
        rowOfNode = round(ceil(k/rows))
        adjNodes = cond do
          rem(k,rows)==1    ->if rem(rowOfNode,2)==0 do
                                [k-rows,k+1]
                              else
                                [k+1,k+rows]
                              end
          rem(k,rows)==0    -> cond do
            rem(rows,2)!=0 -> if rem(rowOfNode,2)==0 do
                                [k-rows,k-1]
                              else
                                [k-1,k+rows]
                              end
            true            -> if rem(rowOfNode,2)!=0 do
                                [k-rows,k-1]
                              else
                                [k-1,k+rows]
                              end
                            end
          rem(rows,2)==1    ->  cond do
            rem(rowOfNode,2)==0 -> if rem(k,2) != 0 do
                                    [k-1,k+1,k+rows]
                                  else
                                    [k-rows,k-1,k+1]
                                  end
            true                -> if rem(k,2) == 0 do
                                    [k-1,k+1,k+rows]
                                  else
                                    [k-rows,k-1,k+1]
                                  end
          end
          true    ->  cond do
            rem(rowOfNode,2)==0 -> if rem(k,2) == 0 do
                                    [k-1,k+1,k+rows]
                                  else
                                    [k-rows,k-1,k+1]
                                  end
            true                -> if rem(k,2) != 0 do
                                    [k-1,k+1,k+rows]
                                  else
                                    [k-rows,k-1,k+1]
                                  end
          end


        end
        adjNodes
      end)

      lastRow = Enum.map(lastRow,fn(k)->
        adjNodes = cond do
          k==((rows*rows)-rows+1)    -> if rem(rows,2) == 0 do
                                          [k-rows,k+1]
                                        else
                                          [k+1]
                                        end
          k==rows*rows -> [k-1]
          rem(k,2)==0    ->  if rem(rows,2) == 0 do
                        [k-1,k+1]
                      else
                        [k-1,k+1,k-rows]
                      end
          true         ->   if rem(rows,2) == 0 do
                              [k-1,k+1,k-rows]
                            else
                              [k-1,k+1]
                            end
        end
        adjNodes
      end)

      adjList = firstRow ++ middleRows ++ lastRow
      Enum.at(adjList,i-1)

    end

    def getRandNeighbours(i,numNodes) do
    adjList = getNeighbours(i,numNodes)
    nodesList = Enum.to_list(1..numNodes)
    adjList = adjList ++ [Enum.random(nodesList -- [i])]
    adjList


    # IO.inspect newAdjList
  end

end
