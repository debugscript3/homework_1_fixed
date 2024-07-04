ENGINE_STATE = false
ELEM_VEHICLE = nil
VEHICLE_OWNER = nil

addCommandHandler("veh", function(player, command, model)
    local WRONG_SYNTAX = "/veh <model>"

    if not tonumber(model) then return outputChatBox(WRONG_SYNTAX, player, 255, 0, 0) end

    local px, py, pz = getElementPosition(player)

    if isElement(ELEM_VEHICLE) then destroyElement(ELEM_VEHICLE) end
    ELEM_VEHICLE = createVehicle(model, px, py+5, pz)
    VEHICLE_OWNER = player
end)

addEventHandler("onVehicleStartEnter", root, function(player)
    if (source == ELEM_VEHICLE) and (player ~= VEHICLE_OWNER) then
        outputChatBox("В автомобиль может сесть только владелец", player, 255, 0, 0)
        cancelEvent()
        return
    end
    ENGINE_STATE = getVehicleEngineState(source)
end)

addEventHandler("onPlayerVehicleEnter", root, function(vehicle)
    if not isElement(ELEM_VEHICLE) or ELEM_VEHICLE ~= vehicle then return end

    if ENGINE_STATE == true then
        setVehicleEngineState(vehicle, true)
    else
        setVehicleEngineState(vehicle, false)
        setVehicleOverrideLights(vehicle, 1)
    end
end)

function VehicleActions_handler(vehicle, action, state)
    if action == "lights" then
        if vehicle ~= ELEM_VEHICLE then return end
        if state ~= 2 then
            setVehicleOverrideLights(vehicle, 2)
        else
            setVehicleOverrideLights(vehicle, 1)
        end
    elseif action == "engine" then
        if ELEM_VEHICLE ~= vehicle then return end
        setVehicleEngineState(vehicle, not state)
    elseif action == "jump" then
        if vehicle ~= ELEM_VEHICLE then return end
        local sx, sy, sz = getElementVelocity(vehicle)
        if sz ~= 0 then return end
        setElementVelocity(vehicle, sx, sy, sz + 0.1)
    end
end
addEvent("onPlayerStartVehicleActions", true)
addEventHandler("onPlayerStartVehicleActions", root, VehicleActions_handler)

addEventHandler("onClientPlayerVehicleEnter", root, function(vehicle)
    if not isElement(ELEM_VEHICLE) or ELEM_VEHICLE ~= vehicle then return end
    VehicleActions_handler(vehicle, "vehicle_enter", ENGINE_STATE)
end)

addEventHandler("onPlayerQuit", root, function()
    if not isElement(ELEM_VEHICLE) or VEHICLE_OWNER ~= source then return end
    destroyElement(ELEM_VEHICLE)
    ELEM_VEHICLE = nil
    VEHICLE_OWNER = nil
    ENGINE_STATE = false
end)