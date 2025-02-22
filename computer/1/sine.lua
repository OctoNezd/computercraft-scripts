X = 1
SZ_X, SZ_Y = term.getSize()
CENTER = math.floor(SZ_Y / 2)
term.clear()
while true do
    Y = CENTER + math.sin(X * .1) * 10
    local term_x = math.fmod(X, SZ_X + 1)
    if term_x == 1 then
        term.setBackgroundColor(colors.black)
        term.clear()
    end
    term.setCursorPos(term_x, Y)
    term.setBackgroundColor(colors.white)
    term.write("x")
    X = X + 1
    sleep(0.01)
end
