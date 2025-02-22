local dfpwm = require "cc.audio.dfpwm"
local strings = require "cc.strings"

local speaker = peripheral.wrap("top")
local monitor = peripheral.wrap("left")
local stop = false
SZ_X, SZ_Y = monitor.getSize()
function main()
    tracks = fs.find("*.dfpwm")
    while true do
        for tracknum = 1, #tracks do
            local track = tracks[tracknum]
            monitor.setCursorPos(1, 1)
            monitor.clear()
            monitor.setTextColor(colors.white)
            local cl = 1
            monitor.write("DFPWM Player")
            cl = cl + 1
            monitor.setCursorPos(1, 2)
            monitor.write("Now playing: ")
            cl = cl + 1
            local lines = strings.wrap(track, SZ_X)
            monitor.setTextColor(colors.green)

            for i = 1, #lines do
                monitor.setCursorPos(1, i + 2)
                monitor.write(lines[i])
                cl = cl + 1
            end
            monitor.setTextColor(colors.white)
            cl = cl + 1
            monitor.setCursorPos(1, cl)
            monitor.write("Playlist (RMB to next track)")
            cl = cl + 1
            for playlist_next_id = tracknum + 1, #tracks do
                monitor.setCursorPos(1, cl)
                local lines = strings.wrap(tracks[playlist_next_id], SZ_X)
                for i = 1, #lines do
                    monitor.setCursorPos(1, cl)
                    monitor.write(lines[i])
                    cl = cl + 1
                end
            end
            local decoder = dfpwm.make_decoder()
            for input in io.lines(track, 16 * 1024) do
                local decoded = decoder(input)
                if stop then
                    stop = false
                    speaker.stop()
                    break
                end
                while not speaker.playAudio(decoded) do
                    os.pullEvent("speaker_audio_empty")
                end
            end
        end
    end
end

local function handleTouch()
    while true do
        os.pullEvent("monitor_touch")
        stop = true
        print("Playback stopped")
    end
end

parallel.waitForAll(main, handleTouch)
