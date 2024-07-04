bindKey("e", "down", function()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not isElement(vehicle) then return end
    triggerServerEvent("onPlayerStartVehicleActions", localPlayer, vehicle, "engine", getVehicleEngineState(vehicle))
end)

bindKey("l", "down", function()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then return end
    triggerServerEvent("onPlayerStartVehicleActions", localPlayer, vehicle, "lights", getVehicleOverrideLights(vehicle))
end)

bindKey("lshift", "down", function()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not isElement(vehicle) then return end
    triggerServerEvent("onPlayerStartVehicleActions", localPlayer, vehicle, "jump", _) 
end)
