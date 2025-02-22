GRID_SIZE = 9
PROTO = "poslua-farm"
local monitor = peripheral.wrap("right")
print(monitor)
peripheral.find("modem", rednet.open)
monitor.setCursorBlink(false)
monitor.setBackgroundColor(colors.black)
monitor.clear()
monitor.setTextScale(1)
FLOORPFX = "Current floor: "
FLOORBLIT = ""
FLOORBLIT_BG = ""
for _ = 1, FLOORPFX:len() do FLOORBLIT = FLOORBLIT .. colors.toBlit(colors.blue) end
for _ = 1, FLOORPFX:len() do FLOORBLIT_BG = FLOORBLIT_BG .. colors.toBlit(colors.black) end
MODEPFX = "Current crop: "
MODEBLIT = ""
MODEBLIT_BG = ""
for _ = 1, MODEPFX:len() do MODEBLIT = MODEBLIT .. colors.toBlit(colors.blue) end
for _ = 1, MODEPFX:len() do MODEBLIT_BG = MODEBLIT_BG .. colors.toBlit(colors.black) end
FLOORBLIT = FLOORBLIT .. colors.toBlit(colors.green)
FLOORBLIT_BG = FLOORBLIT_BG .. colors.toBlit(colors.black)
SLOT_SEEDS = 1
SLOT_POTATO = 2
SLOT_BLOCKFARM = 17
SLOT_SUGARCANE = 18
SLOTS = {
    [SLOT_SEEDS] = "Wheat",
    [SLOT_POTATO] = "Potatoes",
    [SLOT_BLOCKFARM] = "Block Farm",
    [SLOT_SUGARCANE] = "Sugarcane"
}
SIZE_X, SIZE_Y = monitor.getSize()
OFFSET_X = math.floor(SIZE_X / 2) - math.floor(GRID_SIZE / 2)
OFFSET_Y = 4

while true do
    local cid, data = rednet.receive(PROTO)
    print("DATA IN", data)
    monitor.clear()
    monitor.setCursorPos(1, 1)
    local data = textutils.unserialise(data)
    for x = 1, GRID_SIZE do
        monitor.setCursorPos(OFFSET_X - 3, OFFSET_Y + x)
        local row = ""
        local blit = ""
        local blit_bg = ""
        for y = 1, GRID_SIZE do
            for _ = 1, 2 do
                if data.X + 1 == x and data.Y + 1 == y then
                    row = row .. "x"
                    blit = blit .. colors.toBlit(colors.orange)
                    blit_bg = blit_bg .. colors.toBlit(colors.orange)
                else
                    row = row .. "A"
                    blit = blit .. colors.toBlit(colors.gray)
                    blit_bg = blit_bg .. colors.toBlit(colors.gray)
                end
            end
        end
        monitor.blit(row, blit, blit_bg)
    end
    monitor.setCursorPos(math.floor((SIZE_X / 2 - string.len(FLOORBLIT) / 2) + 1), 2)
    monitor.blit(FLOORPFX .. data.AUG.floor, FLOORBLIT, FLOORBLIT_BG)
    local floor = SLOTS[data.AUG.slot]
    local blit = MODEBLIT
    local blit_bg = MODEBLIT_BG
    for _ = 1, floor:len() do
        blit = blit .. colors.toBlit(colors.green)
        blit_bg = blit_bg .. colors.toBlit(colors.black)
    end
    floor = MODEPFX .. floor
    print(floor, blit, blit_bg)
    print(floor:len(), blit:len(), blit_bg:len())
    print("SX", SIZE_X, "SY", SIZE_Y)
    monitor.setCursorPos(math.floor((SIZE_X / 2 - string.len(floor) / 2) + 1), 15)
    monitor.blit(floor, blit, blit_bg, SIZE_X, colors.toBlit(colors.black))
end
