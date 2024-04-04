Config = {}

Config.keybind = 'LSHIFT' -- Keybind to engage/disengage the script

Config.rpmlimiter = 45 -- Recommended values: 35-55
-- The lower the number, the more the engine will rev
-- Increase this number to make the engine rev less

Config.speedlimiter = false -- Enable/Disable speed limiter
Config.defaultspeedlimit = 45 -- Default speed limit if street is not found in the list
Config.speedunits = 'mph' -- Speed units (mph or km/h)

Config.notify = true -- Enable/Disable notifications
Config.notifyengaged = 'Sunday Driving Engaged' -- Notification description when script is engaged
Config.notifydisengaged = 'Sunday Driving Disengaged' -- Notification description when script is disengaged


Config.streets = {
    { name = 'Great Ocean Hwy', speed = 90 },
    { name = 'Senora Freeway', speed = 90 },
    { name = 'Olympic Fwy', speed = 90 },
    { name = 'Del Perro Fwy', speed = 90 },
    { name = 'La Puerta Fwy', speed = 90 },
    { name = 'Los Santos Freeway', speed = 90 },
    { name = 'Palomino Fwy', speed = 90 },
    { name = 'Route 68', speed = 68 },
}