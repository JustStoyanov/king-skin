---@param id string
---@param label string
---@param haircut table?
local saveHaircut = function(id, label, haircut)
    if label then
        MySQL.query('SELECT saved_haircuts FROM character_skins WHERE charId = ?', {
            id
        }, function(result)
            if result[1] then
                local haircuts = json.decode(result[1].saved_haircuts);
                if not haircuts then
                    haircuts = {};
                end
                haircuts[label] = haircut;
                MySQL.update('UPDATE character_skins SET saved_haircuts = ? WHERE charId = ?', {
                    json.encode(haircuts),
                    id
                });
            end
        end);
    end
end
exports('saveHaircut', saveHaircut);

---@param label string
---@param haircut table?
RegisterServerEvent('king-skin:server:saveHaircut', function(label, haircut)
    if Players[source] then
        saveHaircut(Players[source], label, haircut);
    end
end);

---@param src number
---@param label string
---@return table?
local getSavedHaircut = function(src, label)
    local retval = nil;
    if Players[src] then
        local haircut = MySQL.query.await('SELECT saved_haircuts FROM character_skins WHERE charId = ?', {
            Players[src]
        }); if haircut[1] then
            local haircuts = json.decode(haircut[1].saved_haircuts);
            if haircuts then
                retval = haircuts[label];
            end
        end
    end
    return retval;
end
lib.callback.register('king-skin:server:getSavedHaircut', getSavedHaircut);

---@param src number
---@return table
local getSavedHaircuts = function(src)
    local retval = nil;
    if Players[src] then
        local haircut = MySQL.query.await('SELECT saved_haircuts FROM character_skins WHERE charId = ?', {
            Players[src]
        }); if haircut[1] then
            local haircuts = json.decode(haircut[1].saved_haircuts);
            if haircuts then
                retval = haircuts or {};
            end
        end
    end
    return retval;
end
lib.callback.register('king-skin:server:getSavedHaircuts', getSavedHaircuts);

---@param targetId number
---@param label string
RegisterServerEvent('king-skin:server:shareHaircut', function(targetId, label)
    ---@type number
    ---@diagnostic disable-next-line: assign-type-mismatch
    local src = source;
    local haircut = getSavedHaircut(src, label);
    if haircut then
        local name = GetPlayerName(src);
        TriggerClientEvent('king-skin:client:shareHaircut', targetId, name, haircut);
    end
end);

---@param oldname string
---@param newname string
RegisterServerEvent('king-skin:server:renameHaircut', function(oldname, newname)
    local identifier = Players[source];
    if identifier then
        MySQL.query('SELECT saved_haircuts FROM character_skins WHERE charId = ?', {
            identifier
        }, function(result)
            if result then
                if result[1] then
                    local haircuts = json.decode(result[1].saved_haircuts);
                    if haircuts then
                        haircuts[newname] = haircuts[oldname];
                        haircuts[oldname] = nil;
                        MySQL.update('UPDATE character_skins SET saved_haircuts = ? WHERE charId = ?', {
                            json.encode(haircuts),
                            identifier
                        }, function(affectedRows)
                            print('affectedRows', affectedRows);
                        end);
                    end
                end
            end
        end);
    end
end);