lib.addCommand('saveSkin', {
    help = 'Save your current skin to the database.',
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
    local player = args.playerId or src;
    TriggerClientEvent('king-skin:client:saveSkin', player);
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

---@param src number?
---@param identifier number
local saveSavedProps = function(src, identifier)
    if src and identifier then
        local savedProps, data = lib.callback.await('king-skin:client:getSavedProps', src), {};
        if savedProps then
            data = savedProps;
        end MySQL.query('UPDATE character_skins SET prop_status = ? WHERE charId = ?', {
            json.encode(data),
            identifier
        });
    end
end
exports('saveSavedProps', saveSavedProps);

RegisterServerEvent('king-skin:server:saveSavedProps', function()
    if Players[source] then
        ---@diagnostic disable-next-line: param-type-mismatch
        saveSavedProps(source, Players[source]);
    end
end);

---@param identifier number
---@return table?
local getSavedProps = function(identifier)
    if identifier then
        local data = MySQL.query.await('SELECT prop_status FROM character_skins WHERE charId = ?', {
            identifier
        }); if data then
            if data[1] then
                ---@diagnostic disable-next-line: param-type-mismatch
                return json.decode(data[1].prop_status);
            end
        end
    end
end
exports('getSavedProps', getSavedProps);

---@param src number
---@return table?
lib.callback.register('king-skin:server:getSavedProps', function(src)
    if Players[src] then
        ---@diagnostic disable-next-line: param-type-mismatch
        return getSavedProps(Players[src]);
    end
end);