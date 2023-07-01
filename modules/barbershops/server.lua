---@param id string
---@param label string
---@param haircut table?
local saveHaircut = function(id, label, haircut)
    local kvpKey = ('%s:haircut:%s'):format(id, label);
    if label then
        local kvpKey2, haircuts = ('%s:haircuts'):format(id), {};
        if GetResourceKvpString(kvpKey2) then
            haircuts = json.decode(GetResourceKvpString(kvpKey2));
        end if haircut then
            haircuts[label] = haircut;
            SetResourceKvp(kvpKey, json.encode(haircut));
        else
            haircuts[label] = nil;
            DeleteResourceKvp(kvpKey);
        end
        SetResourceKvp(kvpKey2, json.encode(haircuts));
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
        local kvpKey = ('%s:haircut:%s'):format(Players[src], label);
        local haircut = GetResourceKvpString(kvpKey);
        if haircut then
            retval = json.decode(haircut);
        end
    end
    return retval;
end
lib.callback.register('king-skin:server:getSavedHaircut', getSavedHaircut);

---@param src number
---@return table
local getSavedHaircuts = function(src)
    local retval = {};
    if Players[src] then
        local kvpKey = ('%s:haircuts'):format(Players[src]);
        local haircuts = GetResourceKvpString(kvpKey);
        if haircuts then
            retval = json.decode(haircuts);
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