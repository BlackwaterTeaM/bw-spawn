resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
game 'gta5'
author "Alpesh Chaudhary"
description 'bw-spawn'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
client_scripts {
    'config.lua',
    'client.lua',
}
shared_scripts {
    'config.lua'
}
ui_page { 'html/index.html' }

files {
    'html/index.html',
    'html/fonts/*.ttf',
    'html/fonts/*.otf',
    'html/css/*.css',
    'html/images/*.jpg',
    'html/images/*.png',
    'html/js/*.js'
}

lua54 "yes"
