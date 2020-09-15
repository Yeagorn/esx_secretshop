fx_version 'adamant'
game 'gta5'

client_scripts {
    '@es_extended/locale.lua',
    'locales/bg.lua',
    'locales/en.lua',
    'config.lua',
    'client/client.lua',
}

server_scripts {
    'config.lua',
    '@es_extended/locale.lua',
    'locales/bg.lua',
    'locales/en.lua',
    'server/server.lua',
}

dependencies {
    'es_extended',
}