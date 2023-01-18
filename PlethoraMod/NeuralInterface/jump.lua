--program to jump high when 'g' is pressed
local neural = peripheral.find("neuralInterface")
if not neural then error("Must have a neural interface",0) end

local meta = {}
local hover = false

function jumpLoop()
	while(true) do
		local event,key = os.pullEvent()
		if(event == "key" and key == keys.g) then
			neural.launch(0,-90,2)
		end
	end
end

function metadataLoop()
	while(true) do
		meta = neural.getMetaOwner()
	end
end

function safeFallLoop()
	while(true) do
		local blocks = neural.scan()
		for y=0,-8,-1 do
			--scan the block below us
			local block = blocks[1 + (8 + (8 + y)*17 + 8*17^2)]
			if(block.name == "minecraft:air") then 
				if(meta.motionY < -0.3) then
					neural.launch(0,-90,math.min(4,meta.motionY / -0.5))
				end
				break
			end
		end
	end
end

--main loops
parallel.waitForAny(jumpLoop,metadataLoop,safeFallLoop)