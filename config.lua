Config = {}

Config.keybind = 'LSHIFT' -- Keybind to engage/disengage the script

Config.rpmlimiter = 45 -- Recommended values: 35-55
-- The lower the number, the more the engine will rev
-- Increase this number to make the engine rev less

Config.speedlimiter = true -- Enable/Disable speed limiter
Config.speedunits = 'mph' -- Speed units (mph or km/h)
Config.defaultspeedlimit = 45 -- Default speed limit if street is not found in the list
Config.topspeed = 300 -- Default top speed limit of all vehicles 
-- In order for the speed limiter to reset its limit it has to assign a new top speed limit to the vehicle
-- Leave this at 300 for mph or 480 for km/h unless you have a global top speed limit script then change this to your server's top speed limit

Config.notify = true -- Enable/Disable notifications
Config.notifyengaged = 'Sunday Driving Engaged' -- Notification description when script is engaged
Config.notifydisengaged = 'Sunday Driving Disengaged' -- Notification description when script is disengaged
Config.notifyspeedlimit = 'Speed Limit: %s'..Config.speedunits -- Notification description when speed limit changes

Config.cruisehudenabled = true -- Toggle cruise control icon on qb/qbx based HUD's 
-- Only set true if you plan to replace cruise control built into QB/QBX smallresources with this script
-- Tested on qb-hud, qbx_hud and fd_hud


Config.streets = {  -- Add extra streets here that you want toapply a speed limit to. Otherwise unlisted streets will use default speed limit

    { name = 'Great Ocean Hwy', speed = 90 },
    { name = 'Senora Freeway', speed = 90 },
    { name = 'Olympic Fwy', speed = 90 },
    { name = 'Del Perro Fwy', speed = 90 },
    { name = 'La Puerta Fwy', speed = 90 },
    { name = 'Los Santos Freeway', speed = 90 },
    { name = 'Palomino Fwy', speed = 90 },
    { name = 'Route 68', speed = 68 },
}