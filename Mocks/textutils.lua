local t = {}

function t.serialize(obj,options) return "{\n 1,\n 2,\n 3,\n}" end
function t.deserialize(objStr) return {1,2,3} end

return t