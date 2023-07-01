---@param id string
---@param label string
---@param outfit table?
local saveOutfit = function(id, label, outfit)
    local kvpKey = ('%s:outfit:%s'):format(id, label);
    if label then
        local kvpKey2, outfits = ('%s:outfits'):format(id), {};
        if GetResourceKvpString(kvpKey2) then
            outfits = json.decode(GetResourceKvpString(kvpKey2));
        end if outfit then
            outfits[label] = outfit;
            SetResourceKvp(kvpKey, json.encode(outfit));
        else
            outfits[label] = nil;
            DeleteResourceKvp(kvpKey);
        end
        SetResourceKvp(kvpKey2, json.encode(outfits));
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
        local kvpKey = ('%s:outfit:%s'):format(Players[src], label);
        local outfit = GetResourceKvpString(kvpKey);
        if outfit then
            retval = json.decode(outfit);
        end
    end
    return retval;
end
lib.callback.register('king-skin:server:getSavedOutfit', getSavedOutfit);

---@param src number
---@return table
local getSavedOutfits = function(src)
    local retval = {};
    if Players[src] then
        local kvpKey = ('%s:outfits'):format(Players[src]);
        local outfits = GetResourceKvpString(kvpKey);
        if outfits then
            retval = json.decode(outfits);
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