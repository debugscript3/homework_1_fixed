ENGINE_STATE = false
ELEM_VEHICLE = {}

--прям чучут useful шняжек)))
function getPlayerTempVehicle(player)
    if not isElement(player) then return false end

    local vehicle = nil

    for i, v in pairs(ELEM_VEHICLE) do
        if player == v.owner then
            vehicle = v.vehicle
        end
    end
    return vehicle
end

function getVehicleOwner(vehicle)
    if not isElement(vehicle) then return false end

    local owner = nil

    for i, v in pairs(ELEM_VEHICLE) do
        if vehicle == v.vehicle then
            owner = v.owner
        end
    end
    return owner
end

function VehicleActions_handler(player, vehicle, action, state)
    if action == "lights" then
        if vehicle ~= getPlayerTempVehicle(player) then return end
        if state ~= 2 then
            setVehicleOverrideLights(vehicle, 2)
        else
            setVehicleOverrideLights(vehicle, 1)
        end
    elseif action == "engine" then
        if getPlayerTempVehicle(player) ~= vehicle then return end
        setVehicleEngineState(vehicle, not state)
    elseif action == "jump" then
        if vehicle ~= getPlayerTempVehicle(player) then return end
        local sx, sy, sz = getElementVelocity(vehicle)
        if sz ~= 0 then return end
        setElementVelocity(vehicle, sx, sy, sz + 0.1)
    end
end
--end

addCommandHandler("veh", function(player, command, model)
    local WRONG_SYNTAX = "/veh <model>"
    local vehicle = nil

    if not tonumber(model) then return outputChatBox(WRONG_SYNTAX, player, 255, 0, 0) end

    local px, py, pz = getElementPosition(player)

    if isElement(getPlayerTempVehicle(player)) then destroyElement(getPlayerTempVehicle(player)) end

    vehicle = createVehicle(model, px, py+5, pz)
    table.insert(ELEM_VEHICLE, {
        owner = player,
        vehicle = vehicle,
        engine_state = false
    })
end)

addEventHandler("onVehicleStartEnter", root, function(player)
    if (source == getPlayerTempVehicle(player)) and (player ~= getVehicleOwner(source)) then
        outputChatBox("В автомобиль может сесть только владелец", player, 255, 0, 0)
        cancelEvent()
        return
    end

    for i, v in pairs(ELEM_VEHICLE) do
        if v.vehicle == source then
            v.engine_state = getVehicleEngineState(source)
        end
    end
end)

addEventHandler("onPlayerVehicleEnter", root, function(vehicle)
    local player = client or source
    if not isElement(getPlayerTempVehicle(source)) or getPlayerTempVehicle(source) ~= vehicle then return end
    bindKey(player, "e", "down", function()
        local vehicle = getPedOccupiedVehicle(player)
        if not isElement(vehicle) then return end
        VehicleActions_handler(player, vehicle, "engine", getVehicleEngineState(vehicle))
    end)
    bindKey(player, "l", "down", function()
        local vehicle = getPedOccupiedVehicle(player)
        if not vehicle then return end
        VehicleActions_handler(player, vehicle, "lights", getVehicleOverrideLights(vehicle))
    end)
    
    bindKey(player, "lshift", "down", function()
        local vehicle = getPedOccupiedVehicle(player)
        if not isElement(vehicle) then return end
        VehicleActions_handler(player, vehicle, "jump", _)
    end)

    local engine_state = false
    for i, v in pairs(ELEM_VEHICLE) do
        if v.vehicle == vehicle then
            engine_state = v.engine_state
        end
    end
    if engine_state == true then
        setVehicleEngineState(vehicle, true)
    else
        setVehicleEngineState(vehicle, false)
        setVehicleOverrideLights(vehicle, 1)
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if not isElement(getPlayerTempVehicle(source)) or getVehicleOwner(getPlayerTempVehicle(source)) ~= source then return end
    destroyElement(getPlayerTempVehicle(source))
    for i, v in pairs(ELEM_VEHICLE) do
        if v.vehicle == getPlayerTempVehicle(source) then
            table.remove(ELEM_VEHICLE, i)
        end
    end
end)
