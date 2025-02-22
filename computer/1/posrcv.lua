peripheral.find("modem", rednet.open)
print("Receiving messages")
PROTO = "poslua"

while true do
    local cid, data = rednet.receive()
    data = textutils.unserialise(data)
    print("C:2", "X:", data.X, "Y:", data.Y, "Z:", data.Z, "S:", data.SIDE)
end
