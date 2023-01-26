--- This script allows the player to fly, as if they were in creative mode. Be warned, this isn't perfect, and lag may
--- result in your death.

--- Firstly we want to ensure that we have a neural interface and wrap it.
local modules = peripheral.find("neuralInterface")
if not modules then
	error("Must have a neural interface", 0)
end

--- - We require a sensor and introspection module in order to gather information about the player
--- - The sensor is used to determine where the ground is relative to the player, meaning we can slow the player
---   before they hit the floor.
--- - The kinetic augment is (obviously) used to launch the player.
if not modules.hasModule("plethora:sensor") then error("Must have a sensor", 0) end
if not modules.hasModule("plethora:scanner") then error("Must have a scanner", 0) end
if not modules.hasModule("plethora:introspection") then error("Must have an introspection module", 0) end
if not modules.hasModule("plethora:kinetic", 0) then error("Must have a kinetic agument", 0) end

--- We run several loop at once, to ensure that various components do not delay each other.
local meta = modules.getMetaOwner()
local hover = false
parallel.waitForAny(
	--- This loop just pulls user input. It handles a couple of function keys
	---
	--- We recommend running [with the keyboard in your neural interface](../items/keyboard.html#using-with-the-neural-interface),
	--- as this allows you to navigate without having the interface open.
	function()
		while true do
			local event, key = os.pullEvent()
			if event == "key" and key == keys.o then
				-- The O key launches you high into the air.
				modules.launch(0, -90, 3)
			elseif event == "key" and key == keys.p then
				-- The P key launches you a little into the air.
				modules.launch(0, -90, 1)
			elseif event == "key" and key == keys.g then
				-- The g key launches you in whatever direction you are looking.
				modules.launch(meta.yaw, meta.pitch, 3)
			end
		end
	end,
	--- Continuously update the metadata. We do this in a separate loop to ensure this doesn't delay
	--- other functions
	function()
		while true do
			meta = modules.getMetaOwner()
		end
	end
)