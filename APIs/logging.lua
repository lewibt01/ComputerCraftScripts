local l = {}
l.logRoot = "/logs/"

--[[Helper Functions]]
function l.fullPath(fileName)
	return fs.combine(l.logRoot,fileName)
end

function l.init(fileName)
	local logPath = l.fullPath(fileName)
	if(not fs.exists(logPath)) then
		l.wipe(fileName) --should create an empty file
	end
end

--wipe a log file so the output is fresh
function l.wipe(fileName)
	local file = fs.open(l.fullPath(fileName),"w")
	file.write("")
	file.close()
end

function l.write(msg,fileName)
	local logPath = l.fullPath(fileName)
	local file = fs.open(logPath,"w")
	file.write(msg)
	file.close()
end

function l.append(msg,fileName)
	local logPath = l.fullPath(fileName)
	local file = fs.open(logPath,"a")
	file.write(msg)
	file.close()
end

--[[Main Functions]]
--log a message to a file
function l.log(msg,fileName)
	l.init(fileName)
	l.append(msg.."\n",fileName)
end

function l.debug(msg,fileName)
	local tmp = "DEBUG: "..msg
	l.log(tmp,fileName)
end

function l.info(msg,fileName)
	local tmp = "INFO: "..msg
	l.log(tmp,fileName)
end

function l.warn(msg,fileName)
	local tmp = "WARN: "..msg
	l.log(tmp,fileName)
end

function l.error(msg,fileName)
	local tmp = "ERROR: "..msg
	l.log(tmp,fileName)
end

return l