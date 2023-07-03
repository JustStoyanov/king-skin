---@param id string
---@param label string
---@param outfit table?
local saveOutfit = function(id, label, outfit)
    if label then
        MySQL.query('SELECT saved_outfits FROM character_skins WHERE charid = ?', {
            id
        }, function(result)
            if result[1] then
                local outfits = json.decode(result[1].saved_outfits);
                if not outfits then
                    outfits = {};
                end
                outfits[label] = outfit;
                MySQL.update('UPDATE character_skins SET saved_outfits = ? WHERE charid = ?', {
                    json.encode(outfits),
                    id
                });
            end
        end);
    end
end
exports('saveOutfit', saveOutfit);

---@param label string
---@param outfit table?
RegisterServerEvent('king-skin:server:saveOutfit', function(label, outfit)
    if Players[source] then
        saveOutfit(Players[source], label, outfit);
    end
end);

---@param src number
---@param label string
---@return table?
local getSavedOutfit = function(src, label)
    local retval = nil;
    if Players[src] then
        local outfit = MySQL.query.await('SELECT saved_outfits FROM character_skins WHERE charid = ?', {
            Players[src]
        }); if outfit[1] then
            local outfits = json.decode(outfit[1].saved_outfits);
            if outfits then
                retval = outfits[label];
            end
        end
    end
    return retval;
end
lib.callback.register('king-skin:server:getSavedOutfit', getSavedOutfit);

---@param src number
---@return table
local getSavedOutfits = function(src)
    local retval = nil;
    if Players[src] then
        local outfit = MySQL.query.await('SELECT saved_outfits FROM character_skins WHERE charid = ?', {
            Players[src]
        }); if outfit[1] then
            local outfits = json.decode(outfit[1].saved_outfits);
            if outfits then
                retval = outfits or {};
            end
        end
    end
    return retval;
end
lib.callback.register('king-skin:server:getSavedOutfits', getSavedOutfits);

---@param targetId number
---@param label string
RegisterServerEvent('king-skin:server:shareOutfit', function(targetId, label)
    ---@type number
    ---@diagnostic disable-next-line: assign-type-mismatch
    local src = source;
    local outfit = getSavedOutfit(src, label);
    if outfit then
        local name = GetPlayerName(src);
        TriggerClientEvent('king-skin:client:shareOutfit', targetId, name, outfit);
    end
end);

---@param oldname string
---@param newname string
RegisterServerEvent('king-skin:server:renameOutfit', function(oldname, newname)
    local identifier = Players[source];
    if identifier then
        MySQL.query('SELECT saved_outfits FROM character_skins WHERE charid = ?', {
            identifier
        }, function(result)
            if result then
                if result[1] then
                    local outfits = json.decode(result[1].saved_outfits);
                    if outfits then
                        outfits[newname] = outfits[oldname];
                        outfits[oldname] = nil;
                        MySQL.update('UPDATE character_skins SET saved_outfits = ? WHERE charid = ?', {
                            json.encode(outfits),
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