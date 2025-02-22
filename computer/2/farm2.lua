local pos = require("pos")
SLOT_FUEL = 16
SLOT_SEEDS = 1
SLOT_POTATO = 2
SLOT_BLOCKFARM = 17
SLOT_SUGARCANE = 18
FREE_SPACE_START = 3
FREE_SPACE_END = 15
GRID_SIZE = 9
FLOORS = {
    SLOT_SEEDS,
    SLOT_POTATO,
    SLOT_BLOCKFARM,
    SLOT_SUGARCANE
}
CFLOOR = 1
local function harvest_crops()
    for i = 1, GRID_SIZE do
        for j = 1, GRID_SIZE do
            local _, item = turtle.inspectDown()
            if item.state ~= nil then
                if item.state.age == 7 then
                    turtle.digDown()
                    turtle.placeDown()
                end
            end
            if j ~= GRID_SIZE then
                pos.forward()
            end
        end
        if i == GRID_SIZE then break end
        pos.snakeTurn(false)
    end
end
local function harvest_blocks()
    local lines = { 1, 2, 6, 7 }
    for _, line in ipairs(lines) do
        pos.dumbMove(8, line, (CFLOOR - 1) * 4)
        pos.turn(3)
        for _ = 1, GRID_SIZE do
            turtle.digDown()
            if not turtle.inspect() then
                pos.forward()
            end
        end
    end
end
local function harvest_sugar_cane()
    for i = 1, GRID_SIZE - 1 do
        for j = 1, GRID_SIZE - 1 do
            pos.forward()
            local res, insp = turtle.inspect()
            if insp.name == "minecraft:sugar_cane" then
                turtle.dig()
            end
        end
        pos.snakeTurn(true)
    end
end
local function main()
    sleep(2)
    pos.augment_proto("farm")
    pos.dumbMove(0, 0, 0)
    while true do
        pos.turn(1)
        for key, value in pairs(FLOORS) do
            CFLOOR = key
            pos.augment({ floor = key, slot = value })
            print("Floor start!" .. CFLOOR)
            if value == SLOT_BLOCKFARM then
                harvest_blocks()
            elseif value == SLOT_SUGARCANE then
                harvest_sugar_cane()
            else
                turtle.select(value)
                harvest_crops()
            end
            if key ~= #FLOORS then
                pos.dumbMove(0, 0, CFLOOR * 4)
                pos.turn(1)
            end
        end
        pos.dumbMove(0, 0, 0)
        pos.turn(4)
        for i = FREE_SPACE_START, FREE_SPACE_END do
            turtle.select(i)
            turtle.drop()
        end
        if turtle.getItemCount(SLOT_FUEL) == 0 then
            pos.turn(3)
            turtle.select(SLOT_FUEL)
            turtle.suck(64)
        end
        pos.turn(1)
        pos.reset_snake_turn()
        sleep(60)
        os.reboot()
    end
end
return main
