---@type string[]
Players = {};

---@param resource string
---@param exportName string
---@param func function
---@param forCurrent boolean?
ExportHandler = function(resource, exportName, func, forCurrent)
	---@type string
	local name = ('__cfx_export_%s_%s'):format(resource, exportName);
	---@param setCB function
    AddEventHandler(name, function(setCB)
        setCB(func);
    end); if forCurrent then
		exports(exportName, func);
	end
end

-- Functions --

---@param src number
---@param id string
---@return table
local loadAppearance = function(src, id)
	Players[src] = id;
	local data, retval = GetResourceKvpString(('%s:appearance'):format(id)), {};
	if data then
		retval = json.decode(data);
	end
	return retval;
end
ExportHandler('ox_appearance', 'load', loadAppearance, true);

---@param identifier string
---@param appearance table
local saveAppearance = function(identifier, appearance)
	local outfitKey = ('%s:appearance'):format(identifier);
	if appearance then
		SetResourceKvp(outfitKey, json.encode(appearance));
	else
		DeleteResourceKvp(outfitKey);
	end
end
ExportHandler('ox_appearance', 'save', saveAppearance, true);

-- Events --

AddEventHandler('playerDropped', function()
	Players[source] = nil;
end);

---@param appearance table
local saveAppearanceEvent = function(appearance)
	if Players[source] then
		saveAppearance(Players[source], appearance);
	end
end
RegisterServerEvent('king-skin:server:saveAppearance', saveAppearanceEvent);
RegisterServerEvent('ox_appearance:save', saveAppearanceEvent);