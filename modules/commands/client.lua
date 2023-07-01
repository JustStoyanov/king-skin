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

local saveCurrentSkin = function()
	local currentSkin = exports['fivem-appearance']:getPedAppearance(cache.ped);
	TriggerServerEvent('king-skin:server:saveAppearance', currentSkin);
end
exports('saveCurrentSkin', saveCurrentSkin);
RegisterNetEvent('king-skin:client:saveSkin', saveCurrentSkin);