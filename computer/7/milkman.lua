local pos = require("pos")
function select_bucket()
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item ~= nil then
            if item.name == "minecraft:bucket" then
                turtle.select(i)
                return true
            end
        end
    end
    print("Ran out of buckets! Going home!")
    return false
end

function main()
    pos.dumbMove(1, 0, 1)
    pos.turn(1)
    pos.reset_snake_turn()
    local fullstop = false
    for x = 1, 6 do
        for y = 1, 8 do
            pos.forward(1)
            if select_bucket() == false then
                -- ran out of buckets
                fullstop = true
                break
            end
            turtle.placeDown()
        end
        if fullstop then
            break
        end
        pos.forward(1)
        pos.snakeTurn(false)
    end
    pos.dumbMove(0, 0, 0)
    pos.turn(3)
    for slot = 1, 16 do
        local item = turtle.getItemDetail(slot)
        if item ~= nil then
            if item.name == "minecraft:milk_bucket" then
                turtle.select(slot)
                turtle.place()
            end
        end
    end
    sleep(60)
    os.reboot()
end

return main
