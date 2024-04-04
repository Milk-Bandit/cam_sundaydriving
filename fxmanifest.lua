fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

description 'cam_sundaydriving'
version '1.0.0'
author 'Milk Bandit'

shared_script {
    '@ox_lib/init.lua',
}

client_scripts {
    'config.lua',
    'client/client.lua',
}
