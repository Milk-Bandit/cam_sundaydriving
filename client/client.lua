-- Global variables
local sundayDrivingEnabled = false
local speedMultiplier = (Config.speedunits == 'km/h') and 3.6 or 2.236936

-- Function to calculate speed limit based on street name
local function CalculateSpeedLimit(streetName)
    local speedLimit = Config.defaultspeedlimit
    for i = 1, #Config.streets do
        if streetName == Config.streets[i].name then
            speedLimit = Config.streets[i].speed
            break
        end
    end
    return speedLimit
end

-- Function to apply speed limit to vehicle
local function ApplySpeedLimit(veh, speedLimit)
    local currentSpeed = GetEntitySpeed(veh) * speedMultiplier
    if currentSpeed <= speedLimit then
        SetVehicleMaxSpeed(veh, speedLimit / speedMultiplier)
    end
end

-- Function to engage/disengage Sunday driving limits
local function EngageDrivingLimits()
    sundayDrivingEnabled = not sundayDrivingEnabled
    local notifyType = sundayDrivingEnabled and 'success' or 'inform'
    local notifyMessage = sundayDrivingEnabled and Config.notifyengaged or Config.notifydisengaged
    lib.notify({description = notifyMessage, type = notifyType})
    while sundayDrivingEnabled do
        if cache.seat then
            local veh = cache.vehicle
            local pos = GetEntityCoords(cache.ped)
            local street = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
            local streetName = GetStreetNameFromHashKey(street)
            -- Apply speed limit
            if Config.speedlimiter then
                local speedLimit = CalculateSpeedLimit(streetName)
                ApplySpeedLimit(veh, speedLimit)
            end
            -- Apply RPM limit
            local maxRpm = 0.2 + (GetEntitySpeed(veh) / (Config.rpmlimiter * GetVehicleCurrentGear(veh)))
            if GetVehicleCurrentRpm(veh) > maxRpm then
                SetVehicleCurrentRpm(veh, maxRpm)
            end
        end
        Wait(100)
    end
    if not sundayDrivingEnabled then
        SetVehicleMaxSpeed(cache.vehicle, 300 / speedMultiplier)
    end
end

-- Keybind
lib.addKeybind({
    name = 'sundaydriving_bind',
    description = 'Sunday Driving',
    defaultKey = Config.keybind,
    onPressed = function()
        if cache.seat ~= -1 then
            return
        end
        EngageDrivingLimits()
    end
})
