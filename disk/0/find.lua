local pad = require("pad")

local chatBox = peripheral.find("chatBox")
function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function main()
    while true do
        local event, username, message, uuid, isHidden = os.pullEvent("chat")
        local invdata = fs.open("disk/inv.data", "r")
        invdata = invdata.readAll()
        local invs = textutils.unserialise(invdata)
        local findres = {}
        if string.starts(message, "f ") then
            local query = string.sub(message, 3, string.len(message))
            print("looking up", query)
            for chest, inventory in pairs(invs) do
                for _, item in pairs(inventory) do
                    if string.find(item.name, query) then
                        table.insert(findres, ({
                            ["CID"] = chest,
                            ["COUNT"] = item.count,
                            ["NAME"] = item.name,
                        }))
                    end
                end
            end
            local message = "\nCHEST\160\160|\160COUNT\160|\160NAME"
            for _, item in ipairs(findres) do
                message = message ..
                    "\n" ..
                    pad(tostring(item.CID), 6) ..
                    "\160\160|\160" ..
                    pad(tostring(item.COUNT), 5) ..
                    "\160|\160"
                    .. item.NAME
            end
            print(message)
            chatBox.sendMessage(message)
        end
    end
end

return main
