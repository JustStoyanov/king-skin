---@type function
local showSkinMenu = function()
	exports['fivem-appearance']:startPlayerCustomization(function(appearance)
		if appearance then
			TriggerServerEvent('king-skin:server:saveSkin', appearance);
		end
	end, {
		ped = true,
		headBlend = true,
		faceFeatures = true,
		headOverlays = true,
		components = true,
		props = true,
		allowExit = true,
		tattoos = true
	});
end
RegisterNetEvent('king-skin:client:showSkinmenu', showSkinMenu);

RegisterCommand('copySkin', function()
	local currentSkin = exports['fivem-appearance']:getPedAppearance(cache.ped);
	lib.setClipboard(json.encode(currentSkin));
end, false);

local saveCurrentSkin = function()
	local currentSkin = exports['fivem-appearance']:getPedAppearance(cache.ped);
	TriggerServerEvent('king-skin:server:saveAppearance', currentSkin);
end
RegisterNetEvent('king-skin:client:saveSkin', saveCurrentSkin);

RegisterCommand('saveskinbe', saveCurrentSkin, false);

-- Mask/Shirt/Pants/Shoes/Etc --

local propAnims = {
	['hat'] = {
		on = {
			dict = 'mp_masks@standard_car@ds@',
			anim = 'put_on_mask', dur = 600
		}, off = {
			dict = 'missheist_agency2ahelmet',
			anim = 'take_off_helmet_stand', dur = 1200
		}
	}, ['glasses'] = {
		dict = 'clothingspecs',
		anim = 'take_off', dur = 1400
	}, ['ear'] = {
		dict = 'mp_cp_stolen_tut',
		anim = 'b_think', dur = 900
	}, ['watch'] = {
		dict = 'nmt_3_rcm-10',
		anim = 'cs_nigel_dual-10', dur = 1200
	}, ['bracelet'] = {
		dict = 'nmt_3_rcm-10',
		anim = 'cs_nigel_dual-10', dur = 1200
	}
};

---@type table, table
local propCommands, savedProps = {
	['hat'] = 0,
	['glasses'] = 1,
	['ear'] = 2,
	['watch'] = 6,
	['bracelet'] = 7
}, {};

AddEventHandler('ox:playerLogout', function()
	TriggerServerEvent('king-skin:server:saveSavedProps');
end);

AddEventHandler('ox:playerLoaded', function(data)
	lib.callback('king-skin:server:getSavedProps', false, function(dta)
		if dta then
			savedProps = dta;
		else
			savedProps = {};
		end
	end, data.charid);
end);

---@return table?
lib.callback.register('king-skin:client:getSavedProps', function()
	local retval = nil;
	if next(savedProps) then
		retval = savedProps;
		savedProps = {};
	end
	return retval;
end);

---@param prop 'hat' | 'glasses' | 'ear' | 'watch' | 'bracelet'
---@param action 'on' | 'off'
local playPropAnim = function(prop, action)
	local dict, anim, dur = nil, nil, nil;
	if propAnims[prop] then
		if propAnims[prop][action] then
			dict, anim, dur = propAnims[prop][action].dict, propAnims[prop][action].anim, propAnims[prop][action].dur;
		else
			dict, anim, dur = propAnims[prop].dict, propAnims[prop].anim, propAnims[prop].dur;
		end
	end if dict and anim and dur then
		lib.requestAnimDict(dict);
		TaskPlayAnim(cache.ped, dict, anim, 8.0, 8.0, dur, 0, 0, false, false, false);
		Wait(dur);
		ClearPedTasks(cache.ped);
	end
end

CreateThread(function()
	for command, value in pairs(propCommands) do
		RegisterCommand(command, function()
			local props = exports['fivem-appearance']:getPedProps(cache.ped);
			for i = 1, #props do
				local prop = props[i];
				if prop.prop_id == value then
					if prop.drawable ~= -1 then
						savedProps[command] = { drawable = prop.drawable, texture = prop.texture };
						prop.drawable = -1;
						exports['fivem-appearance']:setPedProp(cache.ped, prop);
						local appearance = exports['fivem-appearance']:getPedAppearance(cache.ped);
						TriggerServerEvent('king-skin:server:saveAppearance', appearance);
						playPropAnim(command, 'off');
					else
						if savedProps[command] then
							prop.drawable, prop.texture = savedProps[command].drawable, savedProps[command].texture;
							savedProps[command] = nil;
							exports['fivem-appearance']:setPedProp(cache.ped, prop);
							local appearance = exports['fivem-appearance']:getPedAppearance(cache.ped);
							TriggerServerEvent('king-skin:server:saveAppearance', appearance);
							playPropAnim(command, 'on');
						end
					end
					break;
				end
			end
		end, false);
	end
end);