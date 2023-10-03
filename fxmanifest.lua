fx_version 'cerulean';
game 'gta5';
lua54 'yes';
use_experimental_fxv2_oal 'yes';

author 'gadget2';
description 'A lot of skin features working with fivem-appearance';
version '1.0.0';

client_scripts {
    'code/core/client.lua',
    'code/modules/**/client.lua'
};

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'code/core/server.lua',
    'code/modules/**/server.lua'
};

shared_scripts {
    '@ox_lib/init.lua',
    '@mst-lib/import.lua',

    'config/config.lua'
};

files {
    'code/modules/**/submodules/*.lua',
    'code/modules/**/submodules/**/*.lua'
};
provides {'ox_appearance'};