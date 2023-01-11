local r = {}

function r.open(side) return true end
function r.close(side) return true end
function r.isOpen(side) return true end
function r.send(recipient,message,protocol) return true end
function r.broadcast(message,protocol) return true end
function r.receive(protocol,timeout) return "message" end
function r.host(protocol) return true end
function r.unhost(protocol) return true end
function r.lookup(protocol) return true end

return r