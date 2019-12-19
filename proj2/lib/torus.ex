defmodule Torus do
  def getNeighbours(i,noNodes) do

    r=ceil(:math.pow(noNodes,0.333333))
    x=ceil(i/(r*r))

    neigh=cond do
      x==1 ->neigh=firstPLane(i,r)
      x==r ->neigh=lastPlane(i,r)
      true ->neigh=intemediatePLane(i,x,r)
    end
    # IO.inspect  neigh, charlists: :as_lists
  end

  def firstPLane(i,r) do
    # IO.inspect "This is first plane"

    neigh=cond do
      i==1 -> neigh=[2,r+1,r,r*r+1,r*r-r+1,(r-1)*r*r+1]
      i==r -> neigh=[r-1,2*r,r*r+r,r*r,1,(r-1)*r*r+i]
      i==(r*r-r+1)->neigh=[1,r*r-r+2,r*r-2*r+1,2*r*r-r+1,r*r,r*r*r-r+1]
      i==(r*r) -> neigh=[r*r-1,r*r-r,2*r*r,r,r*r*r,r*r-r+1]
      rem(i,r)==0 ->neigh=[i-1,i-r,i+r,i+r*r,i-r+1,(r-1)*r*r+i]
      rem(i,r)==1 ->neigh=[i+1,i-r,i+r,r*r+i,i+r-1,(r-1)*r*r+i]
      i>1 and i<r ->neigh=[i-1,i+1,i+r,i+r*r,i+(r-1)*r,(r-1)*r*r+i]
      i>r*r-r+1 and i<r*r ->neigh=[i-1,i+1,i-r,i-(r-1)*r,r*r+i,(r-1)*r*r+i]
      true -> neigh=[i-1,i+1,i-r,i+r,i+r*r,i+(r-1)*r*r]
    end
    neigh
  end


  def lastPlane(i,r) do
    neigh=cond do
      i==(r-1)*r*r+1 ->neigh=[(r-1)*r*r+2,(r-1)*r*r+1+r,(r-1)*r*r+1-r*r,(r-1)*r*r+r,1,r*r*r-r+1]
      i==(r-1)*r*r+r -> neigh=[(r-1)*r*r+r-1,(r-1)*r*r+r+r,(r-1)*r*r+r-r*r,r*r*r,(r-1)*r*r+1,r]
      i==r*r*r-r+1 -> neigh=[r*r*r-r+2,r*r*r-r+1-r,r*r*r-r+1-r*r,(r-1)*r*r+1,r*r*r,r*r-r+1]
      i==r*r*r -> neigh=[r*r*r-1,r*r*r-r*r,r*r*r-r,r*r,(r-1)*r*r+r,r*r*r-r+1]
      rem(i,r)==0 -> neigh=[i-1,i+r,i-r,i-r*r,i-r+1,i-(r-1)*r*r]
      rem(i,r)==1 -> neigh=[i+1,i-r,i+r,i-r*r,i+r-1,i-(r-1)*r*r]
      i>(r-1)*r*r+1 and i<(r-1)*r*r+r ->neigh=[i+1,i-1,i+r,i-r*r,i-(r-1)*r*r,i+(r-1)*r]
      i>r*r*r-r+1 and i<r*r*r -> neigh=[i+1,i-1,i-r,i-r*r,i-(r-1)*r*r,i-(r-1)*r]
      true ->  neigh=[i+1,i-1,i+r,i-r,i-r*r,i-(r-1)*r*r]
    end
    neigh
  end

def intemediatePLane(i,x,r) do
  neigh=cond do
    i==(x-1)*r*r+1 ->neigh=[i+1,i+r,i-r*r,i+r*r,x*r*r-r+1,(x-1)*r*r+r]
    i==(x-1)*r*r+r ->neigh=[i-1,i+r,i+r*r,i-r*r,(x-1)*r*r+1,x*r*r]
    i==x*r*r-r+1 ->neigh=[i+1,i-r,i+r*r,i-r*r,(x-1)*r*r+1,x*r*r]
    i==x*r*r -> neigh=[i-1,i-r,i+r*r,i-r*r,x*r*r-r+1,(x-1)*r*r+r]
    rem(i,r)==0 ->neigh=[i-1,i+r,i-r,i+r*r,i-r*r,i-r+1]
    rem(i,r)==1 -> neigh=[i+1,i-r,i+r,i+r*r,i-r*r,i+r-1]
    i>(x-1)*r*r+1 and i<(x-1)*r*r+r -> neigh=[i+1,i-1,i+r,i-r*r,i+r*r,i+(r-1)*r]
    i>x*r*r-r+1 and i<x*r*r -> neigh=[i+1,i-1,i-r,i-r*r,i+r*r,i-(r-1)*r]
    true ->neigh=[i+1,i-1,i+r,i-r,i+r*r,i-r*r]

  end
  #neigh

end

end
