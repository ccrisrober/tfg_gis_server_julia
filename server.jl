# Copyright (c) 2015, maldicion069 (Cristian Rodríguez) <ccrisrober@gmail.con>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.package com.example

import JSON
import Base: run

type KeyObject
  Id::Int64
  PosX::Float64
  PosY::Float64
  Color::String
end

type MapObject
  Id::Int64
  MapFields::String
  Width::Int64
  Height::Int64
  KeyObject::Array{KeyObject}
end

type ObjectUser
  Id::Int64
  PosX::Float64
  PosY::Float64
  Map::Int64
  RollDice::Int64
  Objects::Array{KeyObject}()

  ObjectUser(id, x, y) = new(id, x, y, 0, 0)
end

immutable UserConnected
  client::Base.TcpSocket
  id::Int32
end


global connections = Dict{Int64, UserConnected}()
global positions = Dict{Int64, ObjectUser}()
global counter = 0
global counter_lock = ReentrantLock()
global maps_arr = MapObject[]
global real_objects = Dict{String, KeyObject}()


real_objects["Red"] = new KeyObject(1, 5*64, 5*64, "Red)

function input(prompt::String="")
    print(prompt)
    chomp(readline())
end

is_game = false
opc = input("[S/s] Game Mode / [_] Test Mode")()
if opc == "s" || opc == "S"
    is_game = true
end


println("INICIANDO ... ")

server = listen(ip"127.0.0.1", 8089)

objects_0 = Array{KeyObject}()
push!(objets_0, real_objets["Red"])

push!(maps_arr, MapObject(1,
    string(
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 1,",
  "1, 1, 0, 0, 0, 0, 0, 0, 0, 5, 5, 7, 5, 5, 5, 5, 1, 1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 1,",
  "1, 1, 0, 0, 4, 6, 5, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 4, 0, 5, 5, 5, 0, 8, 8, 8, 0, 0, 1,",
  "1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 4, 0, 0, 0, 1, 1, 0, 5, 5, 5, 0, 0, 0, 8, 8, 8, 4, 0, 1,",
  "1, 0, 1, 0, 0, 0, 0, 4, 0, 0, 1, 1, 1, 1, 4, 0, 0, 0, 1, 0, 5, 0, 4, 4, 0, 0, 8, 8, 8, 1, 4, 1,",
  "4, 0, 1, 0, 0, 0, 0, 4, 4, 0, 1, 1, 1, 1, 1, 1, 4, 0, 1, 0, 5, 0, 4, 4, 4, 0, 8, 8, 8, 1, 1, 1,",
  "1, 0, 1, 0, 0, 4, 4, 4, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 5, 4, 4, 4, 0, 0, 0, 0, 1, 1, 1, 1,",
  "1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 1,",
  "1, 1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5,",
  "1, 1, 0, 0, 4, 0, 5, 5, 5, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 4, 0, 5, 5, 5, 0, 1, 1, 1, 0, 0, 1,",
  "1, 1, 1, 0, 5, 5, 5, 0, 0, 0, 1, 1, 1, 4, 0, 0, 0, 1, 1, 0, 5, 5, 5, 0, 0, 0, 1, 1, 1, 4, 0, 1,",
  "1, 0, 1, 0, 5, 0, 4, 4, 0, 0, 1, 1, 1, 1, 4, 0, 0, 0, 1, 0, 5, 0, 4, 4, 0, 0, 1, 1, 1, 1, 4, 1,",
  "4, 0, 1, 0, 5, 0, 4, 4, 4, 0, 1, 1, 1, 1, 1, 1, 4, 0, 1, 0, 5, 0, 4, 4, 4, 0, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
  "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"),
  32, 25, objects_0))
println(JSON.json(maps_arr[1]))

println("INICIADO :D")

while true
  conn = accept(server)
  println(typeof(conn))
  println(conn.status)
  id = -1
  lock(counter_lock)
    counter += 1
    id = counter
  unlock(counter_lock)
  length(connections)
  println(conn)
  @async begin
   try
      next = true
      while next
        line = readline(conn)
	      println(line)
        try
          j = JSON.parse(line)
          action = string(j["Action"])
          #print(action)
	         if action == "initWName"
    		    connections[id] = UserConnected(conn, id)
    		    positions[id] = ObjectUser(id, 5*64, 5*64)
	 	    println("Enviando mapa ...")
  	            ou = positions[id]
  	            write(conn, JSON.json(Dict{Any, Any}(
      		       "Action" => "sendMap",
      		       "Map" => maps_arr[1],
      		       "X" => ou.PosX,
      		       "Y" => ou.PosY,
      		       "Users" => positions,
      		       "Id" => ou.Id
  	            )))
		    if is_game
		       line = JSON.json(Dict{Any, Any}(
        	          "Action" => "new",
        	          "Id" => ou.Id,
        	          "PosX" => ou.PosX,
        	          "PosY" => ou.PosY
  	               ))
		    end
	         elseif action == "move"
  	            #print("Enviando movimiento ...")
  	            posX = float(j["Pos"]["X"])
  	            posY = float(j["Pos"]["Y"])
  	            ou = positions[id]
  	            ou.PosX = posX
        	    ou.PosY = posY
        	    positions[id] = ou
		    if !is_game
		       write(line)
		    end
	         elseif action == "exit"
	    	    print("Fin de cliente ...")
      		    delete!(connections, id)
      		    delete!(positions, id)
      		    next = false
		    if is_game
		       line = JSON.json(Dict{Any, Any}(
        	          "Action" => "exit",
        	          "Id" => id
                       ))
		    else
		       write(JSON.json(Dict{Any, Any}(
        	          "Action" => "exit",
        	          "Id" => "Me"
                       )))
		    end
          end
        catch ex    
	    #next = false
	end

	#print(" => ")
	#print(id)
	#print(" - ")
        #println(line)
        if is_game
            for (key, value) in connections
	        if key != id
                   println(key)
                   write(value.client, line)
	        end
            end
	end
        # write(conn, line)
      end
    catch ex
      println("Error $ex")
      delete!(connections, id)
      exit = true
    end
  end
end
