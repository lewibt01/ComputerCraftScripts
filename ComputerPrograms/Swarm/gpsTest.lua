package.path = package.path..";/api/?.lua"

s = require("swarm")

peripheral.find("modem",rednet.open)

reuslt = rednet.receive("gpsTest")
print(textutils.unserialize(result))

peripheral.find("modem",rednet.open)