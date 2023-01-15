package.path = package.path..";/api/?.lua"

local swarmHost = 2

s = require("swarm")

peripheral.find("modem",rednet.open)

reuslt = rednet.send(swarmHost,textUtils.serialize("ping"),"gpsTest")
print(result)

peripheral.find("modem",rednet.open)