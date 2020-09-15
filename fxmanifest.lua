fx_version 'adamant'
game 'gta5'

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'client/client.lua',
}

server_scripts {
    'config.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    'server/server.lua',
}

dependencies {
    'es_extended',
    'esx_outlawalert',
    'progressBars'
}
