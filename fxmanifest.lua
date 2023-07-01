fx_version 'cerulean';
game 'gta5';
lua54 'yes';

author 'gadget2';
description 'A lot of skin features working with fivem-appearance';
version '0.0.1';

client_scripts {
    '@ox_core/imports/client.lua',

    'core/client.lua',
    'modules/**/client.lua'
};

server_scripts {
    '@ox_core/imports/server.lua',

    'core/server.lua',
    'modules/**/server.lua'
};

shared_scripts {
    '@ox_lib/init.lua',
    '@king-library/import.lua',

    'config/config.lua'
};
provides {'ox_appearance'};