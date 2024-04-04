local enabled = false

if Config.speedunits == 'km/h' then
    speedMultiplier = 3.6
else    
    speedMultiplier = 2.236936
end

local function EngageSpeedLimit()
    CreateThread(function()
        while enabled do

            if cache.seat then

                local veh = GetVehiclePedIsIn(PlayerPedId())
                local pos = GetEntityCoords(PlayerPedId())
                local street = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                local streetName = GetStreetNameFromHashKey(street)

                for i = 1, #Config.streets do
                    if streetName == Config.streets[i].name then
                        speedLimit = Config.streets[i].speed
                        break
                    else
                        speedLimit = Config.defaultspeedlimit
                    end
                end

                if GetEntitySpeed(cache.vehicle) * speedMultiplier <= speedLimit then
                    SetVehicleMaxSpeed(cache.vehicle, speedLimit / speedMultiplier)
                end

            end
            Wait(250)
        end
    end)
end

local function EngageRpmLimit()
    while enabled do

        local veh = GetVehiclePedIsIn(PlayerPedId())

        if cache.seat then

            local maxRpm = 0.2 + (GetEntitySpeed(veh) / (Config.rpmlimiter * GetVehicleCurrentGear(veh)))

            if GetVehicleCurrentRpm(cache.vehicle) > maxRpm then
                SetVehicleCurrentRpm(cache.vehicle, maxRpm)
            end

        end
        Wait(10)
    end
end

local keybind = lib.addKeybind({
    name = 'sundaydriving',
    description = 'Sunday Driving',
    defaultKey = Config.keybind,
    onPressed = function(self)
        if enabled then
            if Config.notify then
                lib.notify({description = Config.notifydisengaged, type = 'inform'})
            end
            enabled = false
            SetVehicleMaxSpeed(cache.vehicle, 300 / speedMultiplier)
        else
            enabled = true
            if Config.speedlimiter then
                EngageSpeedLimit()
            end
            EngageRpmLimit()
            if Config.notify then
                lib.notify({description = Config.notifyengaged, type = 'success'})
            end
        end
    end,
})

lib.onCache('seat', function(value)
    if value == -1 then 
        keybind:disable(false)
    else
        keybind:disable(true)
        enabled = false
        SetVehicleMaxSpeed(cache.vehicle, 300 / speedMultiplier)
    end
end)
