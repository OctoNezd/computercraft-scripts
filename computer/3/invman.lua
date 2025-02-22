---@diagnostic disable: lowercase-global
local pos = require("pos")
ROW_CHEST_COUNT = 7
FLOORS = 2
local function main()
    sleep(1)
    while true do
        pos.dumbMove(0, 0, 0)
        local inv = {}
        for floor = 1, FLOORS do
            print(floor)
            for x = 1, ROW_CHEST_COUNT do
                local is = (floor - 1) * ROW_CHEST_COUNT + x
                x = x * 2
                pos.dumbMove(x, 0, floor - 1)
                pos.turn(1)
                print("FL:", floor, "X:", x, "IS:", is)
                local chest = peripheral.wrap("right")
                inv[is] = chest.list()
            end
        end
        pos.dumbMove(ROW_CHEST_COUNT * 2 + 1, 0, 0)
        assert(fs.exists("disk"))
        local fh = fs.open("disk/inv.data", "w")
        fh.write(textutils.serialize(inv))
        fh.close()
        print("Saved inventory to disk/inv.data")
        pos.dumbMove(0, 0, 0)
        sleep(60)
    end
end
return main
