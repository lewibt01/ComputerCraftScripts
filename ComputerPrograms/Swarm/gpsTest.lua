package.path = package.path..";/api/?.lua"

s = require("swarm")

peripheral.find("modem",rednet.open)

reuslt = rednet.receive("gpsTest",5)
print(textutils.unserialize(result))

peripheral.find("modem",rednet.open)