local arg = { ... }

function interpret(input)
    for i=1,string.len(input) do
        tmp = string.sub(input,i,i)
        --movement functions
        if tmp=="f" 
            then turtle.forward()
        elseif tmp=="l" 
            then turtle.turnLeft()
        elseif tmp=="r" 
            then turtle.turnRight()
        elseif tmp=="b" 
            then turtle.back()
        elseif tmp=="d" 
            then turtle.down()
        elseif tmp=="u" 
            then turtle.up()
        end
       
        --passive ensured movement functions
        ---will wait until whatever is in front of them moves away
        if tmp=="q" then
            while not turtle.forward() do sleep(0.1) end
        
        elseif tmp=="e" then
            while not turtle.up() do sleep(0.1) end
        
        elseif tmp=="c" then
            while not turtle.down() do sleep(0.1) end
        
        end

        --aggressive ensured movement functions
        ---will check for obstacles, and will try to remove them
        if tmp=="Q" then
            while not turtle.forward() do
                turtle.dig()
                turtle.attack()
            end
        
        elseif tmp=="E" then
            while not turtle.up() do
                turtle.digUp()
                turtle.attack()
            end
        
        elseif tmp=="C" then
            while not turtle.down() do
                turtle.digDown()
                turtle.attack()
            end
        end
       
        --dig functions...
        if tmp=="D" then turtle.digDown()
        elseif tmp=="U" then turtle.digUp()
        elseif tmp=="F" then turtle.dig()
        end
       
        --placement functions...
        if tmp=="P" then turtle.place() 
        elseif tmp=="A" then turtle.placeUp() 
        elseif tmp=="B" then turtle.placeDown()
        end
       
        --inventory management...
        if tmp=="1" then turtle.select(1) 
        elseif tmp=="2" then turtle.select(2) 
        elseif tmp=="3" then turtle.select(3) 
        elseif tmp=="4" then turtle.select(4) 
        elseif tmp=="5" then turtle.select(5) 
        elseif tmp=="6" then turtle.select(6) 
        elseif tmp=="7" then turtle.select(7) 
        elseif tmp=="8" then turtle.select(8) 
        elseif tmp=="9" then turtle.select(9) 
        elseif tmp=="0" then turtle.select(10) 
        elseif tmp=="!" then turtle.select(11) 
        elseif tmp=="@" then turtle.select(12) 
        elseif tmp=="#" then turtle.select(13) 
        elseif tmp=="$" then turtle.select(14) 
        elseif tmp=="%" then turtle.select(15) 
        elseif tmp=="^" then turtle.select(16) 
        end
    end
end

interpret(table.concat(arg))