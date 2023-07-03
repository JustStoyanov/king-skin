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
	local retval = {};
	local data = MySQL.query.await([[
		SELECT current_skin FROM 
		character_skins WHERE charid = ?
	]], { id });
	if data then
		if data[1] then
			if #data > 1 then
				error('DUPLICATING SKIN DATA FOR '..id);
			end
			retval = json.decode(data[1].current_skin);
		end
	end
	return retval;
end
ExportHandler('ox_appearance', 'load', loadAppearance, true);

---@param identifier string
---@param appearance table
local saveAppearance = function(identifier, appearance)
	if appearance then
		MySQL.query('SELECT current_skin FROM character_skins WHERE charid = ?', {
			identifier
		}, function(result)
			if result then
				if not result[1] then
					MySQL.insert([[
						INSERT INTO character_skins (charid, current_skin) VALUES (?, ?) 
					]], {
						identifier,
						json.encode(appearance)
					});
				else
					MySQL.update([[
						UPDATE character_skins SET current_skin = ? WHERE charid = ?
					]], {
						json.encode(appearance),
						identifier
					});
				end
			else
				MySQL.insert([[
					INSERT INTO character_skins (charid, current_skin) VALUES (?, ?) 
				]], {
					identifier,
					json.encode(appearance)
				});
			end
		end)
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