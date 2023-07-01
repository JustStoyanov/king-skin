lib.addCommand('saveSkin', {
    help = 'Save your current skin to the database.'
}, function(src)
    TriggerClientEvent('king-skin:client:saveSkin', src);
end);

lib.addCommand('skin', {
    help = 'Give skin menu to player',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Player ID',
	        optional = true
	    }
    },
    restricted = 'group.admin'
}, function(src, args)
    local target = src;
    if args.target then
        target = args.target;
    end
    TriggerClientEvent('king-skin:client:showSkinmenu', target);
end);