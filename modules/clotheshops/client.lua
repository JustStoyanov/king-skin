---@type function
local buyClothes = function()
    ShowFiveMAppearance('Clotheshop', {
		ped = false,
		headBlend = false,
		faceFeatures = false,
		headOverlays = false,
		components = true,
		props = true,
		tattoos = false,
		allowExit = true
	});
end

local saveClothes = function()
    local input = lib.inputDialog('Save Outfit', {'Outfit Label:'});
    if not input or not input?[1] or input?[1] == '' then
        return;
    end
    local props = exports['fivem-appearance']:getPedProps(cache.ped);
    local components = exports['fivem-appearance']:getPedComponents(cache.ped);
    for index, value in pairs(components) do
        if value['component_id'] == 0 then
            table.remove(components, index)
            break;
        end
    end local outfitData = {
        props = props,
        clothes = components
    };
    TriggerServerEvent('king-skin:server:saveOutfit', input[1], outfitData);
end

--[[ props
    [
        {"texture":-1,"prop_id":0,"drawable":-1},
        {"texture":-1,"prop_id":1,"drawable":-1},
        {"texture":-1,"prop_id":2,"drawable":-1},
        {"texture":-1,"prop_id":6,"drawable":-1},
        {"texture":-1,"prop_id":7,"drawable":-1}
    ]
    components
    [
        {"component_id":1,"drawable":35,"texture":0}, -- mask
        {"component_id":8,"drawable":15,"texture":0}, -- shirt
        {"component_id":4,"drawable":16,"texture":1}, -- legs
        {"component_id":6,"drawable":7,"texture":9}, -- shoes
        {"component_id":11,"drawable":347,"texture":12} -- jacket
        {"component_id":3,"drawable":15,"texture":0}, -- hands
        {"component_id":10,"drawable":0,"texture":0}, -- decals
        {"component_id":9,"drawable":0,"texture":0}, -- armor/vests
        {"component_id":7,"drawable":0,"texture":0}, -- chains
        {"component_id":5,"drawable":0,"texture":0}, -- parachute
        {"component_id":2,"drawable":1,"texture":0}, -- hair

        {"component_id":0,"drawable":0,"texture":0}, --! THIS SHOULD BE REMOVED
    ]
]]--

---@param data table
local savedOutfitsMenus = function(data)
    lib.registerContext({
        id = 'saved_outfitsmenu_king_skin',
        title = data.index,
        menu = 'clotheshop_menu_king_skin',
        options = {
            {
                title = 'Apply Outfit',
                onSelect = function()
                    exports['fivem-appearance']:setPedProps(cache.ped, data.data.props);
                    exports['fivem-appearance']:setPedComponents(cache.ped, data.data.clothes);
                    local currentAppearance = exports['fivem-appearance']:getPedAppearance(cache.ped);
                    TriggerServerEvent('king-skin:server:saveAppearance', currentAppearance);
                end
            },
            {
                title = 'Share Outfit',
                onSelect = function()
                    local menuOptions = {};
                    for _, player in pairs(GetActivePlayers()) do
                        local ped = GetPlayerPed(player);
                        if ped ~= cache.ped then
                            local coords = GetEntityCoords(ped);
                            if #(coords - GetEntityCoords(cache.ped)) <= 3.0 then
                                menuOptions[#menuOptions + 1] = {
                                    title = GetPlayerName(player),
                                    onSelect = function()
                                        TriggerServerEvent('king-skin:server:shareOutfit', GetPlayerServerId(player), data.index);
                                    end
                                };
                            end
                        end
                    end if #menuOptions == 0 then
                        menuOptions[1] = { title = 'No Players Nearby' };
                    end
                    lib.registerContext({
                        id = 'share_outfit_king_skin',
                        title = 'Share Outfit',
                        menu = 'saved_outfitsmenu_king_skin',
                        options = menuOptions
                    });
                    lib.showContext('share_outfit_king_skin');
                end
            },
            {
                title = 'Rename Outfit',
                onSelect = function()
                    local input = lib.inputDialog('Rename Outfit', {'Outfit Label:'});
                    if not input or not input?[1] or input?[1] == '' then
                        return;
                    end
                    TriggerServerEvent('king-skin:server:saveOutfit', data.index, nil);
                    TriggerServerEvent('king-skin:server:saveOutfit', input[1], data.data);
                end
            },
            {
                title = 'Delete Outfit',
                onSelect = function()
                    TriggerServerEvent('king-skin:server:saveOutfit', data.index);
                end
            }
        }
    });
    lib.showContext('saved_outfitsmenu_king_skin');
end

---@type function
local savedOutfits = function()
    local outfits = lib.callback.await('king-skin:server:getSavedOutfits', false);
    local menuOptions = {
        id = 'saved_outfits_king_skin',
        title = 'Saved Outfits',
        menu = 'clotheshop_menu_king_skin',
        options = {}
    }; if outfits then
        local options = menuOptions.options;
        for index, value in pairs(outfits) do
            options[#options + 1] = {
                title = index,
                arrow = true,
                onSelect = savedOutfitsMenus,
                args = { index = index, data = value }
            }
        end if #options == 0 then
            options[1] = { title = 'No Outfits Saved' };
        end
    else
        local option = menuOptions.options;
        option[1] = { title = 'No Outfits Saved' };
    end
    lib.registerContext(menuOptions);
    lib.showContext('saved_outfits_king_skin');
end

lib.registerContext({
    id = 'clotheshop_menu_king_skin',
    title = 'Clothe Shop',
    options = {
        {
            title = 'Buy Clothes',
            onSelect = buyClothes
        },
        {
            title =  'Save Clothes',
            onSelect = saveClothes,
        },
        {
            title = 'Saved Outfits',
            onSelect = savedOutfits,
            arrow = true
        }
    }
});

---@param playerName string
---@param outfit table
RegisterNetEvent('king-skin:client:shareOutfit', function(playerName, outfit)
    local decision = lib.alertDialog({
        header = ('%s wants to share an outfit with you.'):format(playerName),
        content = 'If you accept, your current outfit will be changed!',
        centered = true,
        cancel = true
    }); if decision == 'confirm' then
        exports['fivem-appearance']:setPedProps(cache.ped, outfit.props);
        exports['fivem-appearance']:setPedComponents(cache.ped, outfit.clothes);
        local currentAppearance = exports['fivem-appearance']:getPedAppearance(cache.ped);
        TriggerServerEvent('king-skin:server:saveAppearance', currentAppearance);
    end
end);