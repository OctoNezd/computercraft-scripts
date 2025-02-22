-- https://github.com/blitmap/lua-snippets/blob/master/string-pad.lua
local srep = string.rep

-- pad the right side
rpad =
    function(s, l, c)
        local res = s .. srep(c or "\160", l - #s)

        return res, res ~= s
    end

return rpad
