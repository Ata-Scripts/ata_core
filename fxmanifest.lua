fx_version 'cerulean'
game 'gta5'
author 'ATA REVALS - https://github.com/atarevals'
description 'All Rights Reserved - ata.tebex.io'
version '1.0.5' 
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua'
}

client_scripts {
	'client/main.lua',
	'client/can-edit.lua',
	'client/CreateNPC.lua'
}

server_scripts {
	'server/database.lua',
	'server/main.lua'
}


dependencies {
	'ox_lib'
}
