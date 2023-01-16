package.path = package.path..";/api/?.lua"

local swarmHost = 2

s = require("swarm")

peripheral.find("modem",rednet.open)

local msg = textutils.serialize({gps.locate()})
print("Attempting to send:",msg)

result = rednet.send(swarmHost,msg,"gpsTest")

print(result)

peripheral.find("modem",rednet.close)