fx_version 'cerulean'
games { 'gta5' };

name 'RageUI';

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",

    "src/components/*.lua",

    "src/menu/elements/*.lua",

    "src/menu/items/*.lua",

    "src/menu/panels/*.lua",

    "src/menu/windows/*.lua",

}

shared_scripts {
     'config.lua'
}


client_scripts {
     'cl_bat_armurie.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
     'sv_bat_armurie.lua',
}


