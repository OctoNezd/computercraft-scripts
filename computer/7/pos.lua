X = 0
Y = 0
Z = 0
-- 1
--4 2
---3
SIDE = 1
DEBUG = false
AUG = nil
local function loadCoords()
    if fs.exists("coords") then
        local text = fs.open("coords", "r")
        local data = text.readAll()
        text.close()
        table = textutils.unserialise(data)
        X = table.X
        Y = table.Y
        Z = table.Z
        SIDE = table.SIDE
    end
end
loadCoords()
local function print_debug(msg)
    if DEBUG then print(msg) end
end
local function enable_debug() DEBUG = true end

local function actModem()
    -- Open all modems
    peripheral.find("modem", rednet.open)
    print("Open modem?", rednet.isOpen())
end
actModem()
PROTO = "poslua"
local function preheat()
    local curslot = turtle.getSelectedSlot()
    if turtle.getFuelLevel() < 100 then
        print("Refueling")
        turtle.select(SLOT_FUEL)
        turtle.refuel(64)
    end
    turtle.select(curslot)
end
local function recalc_pos(amount)
    if SIDE == 1 then X = X + amount end
    if SIDE == 2 then Y = Y + amount end
    if SIDE == 3 then X = X - amount end
    if SIDE == 4 then Y = Y - amount end
    table = {
        X = X,
        Y = Y,
        Z = Z,
        SIDE = SIDE,
        AUG = AUG
    }
    print_debug("new pos:" .. X .. Y .. Z)
    local fh = fs.open("coords", "w")
    local data = {
        X = X,
        Y = Y,
        Z = Z,
        SIDE = SIDE,
    }
    fh.write(textutils.serialise(data))

    rednet.broadcast(textutils.serialise(table), PROTO)
end
local function forward(amount)
    preheat()
    if amount == nil then amount = 1 end
    for _ = 1, amount do
        local res, insp = turtle.inspect()
        if insp.name == "minecraft:sugar_cane" then
            turtle.dig()
        end
        local res = turtle.forward()
        if not res then
            print("failed to move forward", res)
        end
        if res then recalc_pos(1) end
    end
end
local function back(amount)
    preheat()
    if amount == nil then amount = 1 end
    for _ = 1, amount do
        local res = turtle.back()
        if res then recalc_pos(-1) end
    end
end
local function turn(desired_side)
    while SIDE ~= desired_side do
        SIDE = SIDE + 1
        if SIDE > 4 then SIDE = 1 end
        turtle.turnRight()
    end
    recalc_pos(0)
end
SNAKE_TURN = true
local function reset_snake_turn() SNAKE_TURN = false end
local function snakeTurn(cane)
    if SNAKE_TURN then
        SIDE = SIDE + 1
        turtle.turnRight()
    else
        SIDE = SIDE - 1
        turtle.turnLeft()
    end
    local res, insp = turtle.inspect()
    if insp.name == "minecraft:sugar_cane" then
        turtle.dig()
    end
    if SIDE > 4 then SIDE = 1 end
    if SIDE < 1 then SIDE = 4 end
    recalc_pos(0)
    forward()
    local res, insp = turtle.inspect()
    if insp.name == "minecraft:sugar_cane" then
        turtle.dig()
    end
    if SNAKE_TURN then
        SIDE = SIDE + 1
        turtle.turnRight()
    else
        SIDE = SIDE - 1
        turtle.turnLeft()
    end
    local res, insp = turtle.inspect()
    if insp.name == "minecraft:sugar_cane" then
        turtle.dig()
    end
    SNAKE_TURN = not SNAKE_TURN
    if SIDE > 4 then SIDE = 1 end
    if SIDE < 1 then SIDE = 4 end
    recalc_pos(0)
end
local function up(amount)
    preheat()
    if amount == nil then amount = 1 end
    for _ = 1, amount do
        local res = turtle.up()
        if res then Z = Z + 1 end
    end
    -- Call recalc_pos to broadcast new coords
    recalc_pos(0)
end
local function down(amount)
    preheat()
    if amount == nil then amount = 1 end
    for _ = 1, amount do
        local res = turtle.down()
        if res then Z = Z - 1 end
    end
    recalc_pos(0)
end
local function getpos()
    return X, Y, Z, SIDE
end
local function dumbMove(x, y, z)
    local destination = vector.new(x, y, z)
    local calculated = destination - vector.new(X, Y, Z)
    local move_x, move_y, move_z = calculated.x, calculated.y, calculated.z
    if move_x < 0 then
        turn(3)
        while X ~= x do
            forward()
        end
    elseif move_x > 0 then
        turn(3)
        while X ~= x do
            back()
        end
    end
    if move_y < 0 then
        turn(4)
        while Y ~= y do
            forward()
        end
    elseif move_y > 0 then
        turn(2)
        while Y ~= y do
            forward()
        end
    end
    if move_z < 0 then
        while Z ~= z do
            down()
        end
    elseif move_z > 0 then
        while Z ~= z do
            up()
        end
    end
end
local function augment(data)
    AUG = data
end
local function augment_proto(proto)
    PROTO = "poslua-" .. proto
end
return {
    forward = forward,
    back = back,
    turn = turn,
    getpos = getpos,
    up = up,
    down = down,
    snakeTurn = snakeTurn,
    dumbMove =
        dumbMove,
    enable_debug = enable_debug,
    reset_snake_turn = reset_snake_turn,
    augment = augment,
    augment_proto = augment_proto,
}
