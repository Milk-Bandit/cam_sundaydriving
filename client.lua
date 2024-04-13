-- Global variables
local sundayDrivingEnabled = false
local speedMultiplier = (Config.speedunits == 'km/h') and 3.6 or 2.236936
local speedLimit = Config.defaultspeedlimit

-- Function to calculate speed limit based on street name
local function CalculateSpeedLimit()
    CreateThread(function()
        local veh = cache.vehicle
        while sundayDrivingEnabled do
            local currentSpeedLimit = speedLimit
            if cache.seat then
                speedLimit = Config.defaultspeedlimit
                local pos = GetEntityCoords(cache.ped)
                local street = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                local streetName = GetStreetNameFromHashKey(street)
                for i = 1, #Config.streets do
                    if streetName == Config.streets[i].name then
                        speedLimit = Config.streets[i].speed
                        break
                    end
                end
            end
            -- Notify player if speed limit changes
            if currentSpeedLimit ~= speedLimit then 
                local notifyType = (GetEntitySpeed(veh) * speedMultiplier > speedLimit) and 'warning' or 'inform'
                local notifyMessage = (GetEntitySpeed(veh) * speedMultiplier > speedLimit) and Config.notifyspeedlimitexceed or Config.notifyspeedlimit
                lib.notify({description = string.format(notifyMessage, speedLimit), type = notifyType})
            end
            Wait(1000)
        end
        -- Reset speed limit to default when Sunday driving is disengaged
        if not sundayDrivingEnabled then
            SetVehicleMaxSpeed(veh, Config.topspeed / speedMultiplier)
        end
    end)
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
            -- Apply speed limit
            if Config.speedlimiter then
                ApplySpeedLimit(veh, speedLimit)
            end
            -- Apply RPM limit
            local maxRpm = 0.2 + (GetEntitySpeed(veh) / (Config.rpmlimiter * GetVehicleCurrentGear(veh)))
            if GetVehicleCurrentRpm(veh) > maxRpm then
                SetVehicleCurrentRpm(veh, maxRpm)
            end
        end
        Wait(10)
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
        if Config.cruisehudenabled then
            TriggerEvent('seatbelt:client:ToggleCruise')
        end
        CalculateSpeedLimit()
        EngageDrivingLimits()
    end
})

-- Check when player enters vehicle and Sunday driving is engaged for cruise control display on QB based HUD's
lib.onCache('seat', function(value)
    if value == not -1 then
        sundayDrivingEnabled = false
        lib.notify({description = Config.notifydisengaged, type = 'inform'})
    end
end)