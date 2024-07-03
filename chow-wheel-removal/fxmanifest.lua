fx_version 'cerulean'
game 'gta5'

author 'ChowScripts'
description 'Wheel Removal Script By Chow Scripts'
version '1.0.0'

shared_script '@qb-core/shared/locale.lua'
server_script 'server.lua'
client_script 'client.lua'

escrow_ignore {
    
    'client.lua',
    'server.lua'

    
  }
lua54 'yes'
dependency '/assetpacks'