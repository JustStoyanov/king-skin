---@type function
local changeHair = function()
    ShowFiveMAppearance('Barbershop', {
		ped = false,
		headBlend = false,
		faceFeatures = false,
		headOverlays = true,
		components = false,
		props = false,
		tattoos = false,
		allowExit = true
	});
end

---@type function
---@return nil
local saveHaircut = function()
    local input = lib.inputDialog('Save Haircut', {'Haircut Label:'});
    if not input or not input?[1] or input?[1] == '' then
        return;
    end
    local beard, chestHair in exports['fivem-appearance']:getPedHeadOverlays(cache.ped);
    local hairData = {
        hair = exports['fivem-appearance']:getPedHair(cache.ped),
        beard = beard,
        chestHair = chestHair
    };
    TriggerServerEvent('king-skin:server:saveHaircut', input[1], hairData);
end

---@param data table
local savedHaircutMenu = function(data)
    lib.registerContext({
        id = 'saved_haircutmenu_king_skin',
        title = data.index,
        menu = 'barbershop_menu_king_skin',
        options = {
            {
                title = 'Apply Haircut',
                onSelect = function()
                    exports['fivem-appearance']:setPedHair(cache.ped, data.data.hair);
                    local headOverlays = exports['fivem-appearance']:getPedHeadOverlays(cache.ped);
                    headOverlays['beard'] = data.data.beard;
                    headOverlays['chestHair'] = data.data.chestHair;
                    exports['fivem-appearance']:setPedHeadOverlays(cache.ped, headOverlays);
                    local currentAppearance = exports['fivem-appearance']:getPedAppearance(cache.ped);
                    TriggerServerEvent('king-skin:server:saveAppearance', currentAppearance);
                end
            },
            {
                title = 'Share Haircut',
                onSelect = function()
                    local menuOptions = {};
                    for _, player in pairs(GetActivePlayers()) do
                        local ped = GetPlayerPed(player);
                        if ped ~= cache.ped then
                            local coords = GetEntityCoords(ped);
                            if #(coords - GetEntityCoords(cache.ped)) <= 3.0 then
                                menuOptions[#menuOptions + 1] = {
                                    title = GetPlayerName(player),
                                    arrow = true,
                                    onSelect = function()
                                        local id = GetPlayerServerId(player);
                                        TriggerServerEvent('king-skin:server:shareHaircut', id, data.index);
                                    end
                                };
                            end
                        end
                    end if #menuOptions == 0 then
                        menuOptions[1] = { title = 'No Players Nearby' };
                    end lib.registerContext({
                        id = 'share_haircut_king_skin',
                        title = 'Share Outfit',
                        menu = 'barbershop_menu_king_skin',
                        options = menuOptions
                    });
                    lib.showContext('share_haircut_king_skin');
                end
            },
            {
                title = 'Rename Haircut',
                onSelect = function()
                    local input = lib.inputDialog('Rename Haircut', {'Haircut Label:'});
                    if not input or not input?[1] or input?[1] == '' then
                        return;
                    end
                    TriggerServerEvent('king-skin:server:renameHaircut', data.index, input[1]);
                end
            },
            {
                title = 'Delete Haircut',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = 'Are you sure you want to delete this haircut?',
                        centered = true,
                        cancel = true
                    }); if alert == 'confirm' then
                        TriggerServerEvent('king-skin:server:saveHaircut', data.index, nil);
                    else
                        lib.showContext('saved_haircutmenu_king_skin');
                    end
                end
            }
        }
    });
    lib.showContext('saved_haircutmenu_king_skin');
end

---@type function
local savedHaircuts = function()
    local haircuts = lib.callback.await('king-skin:server:getSavedHaircuts', false);
    local menuOptions = {
        id = 'saved_haircuts_king_skin',
        title = 'Saved Haircuts',
        menu = 'barbershop_menu_king_skin',
        options = {}
    }; if haircuts then
        local options = menuOptions.options;
        for index, value in pairs(haircuts) do
            options[#options + 1] = {
                title = index,
                arrow = true,
                onSelect = savedHaircutMenu,
                args = { index = index, data = value }
            }
        end if #options == 0 then
            options[1] = { title = 'No Haircuts Saved' };
        end
    else
        local option = menuOptions.options;
        option[1] = { title = 'No Haircuts Saved' };
    end
    lib.registerContext(menuOptions);
    lib.showContext('saved_haircuts_king_skin');
end

lib.registerContext({
    id = 'barbershop_menu_king_skin',
    title = 'Barber',
    options = {
        {
            title = 'Change Haircut',
            onSelect = changeHair
        },
        {
            title =  'Save Haircut',
            onSelect = saveHaircut
        },
        {
            title = 'Saved Haircuts',
            onSelect = savedHaircuts,
            arrow = true
        }
    }
});

---@param playerName string
---@param haircut table
RegisterNetEvent('king-skin:client:shareHaircut', function(playerName, haircut)
    local decision = lib.alertDialog({
        header = ('%s wants to share a haircut with you.'):format(playerName),
        content = 'If you accept, your current haircut will be changed!',
        centered = true,
        cancel = true
    }); if decision == 'confirm' then
        exports['fivem-appearance']:setPedHair(cache.ped, haircut.hair);
        local headOverlays = exports['fivem-appearance']:getPedHeadOverlays(cache.ped);
        headOverlays['beard'] = haircut.beard;
        headOverlays['chestHair'] = haircut.chestHair;
        exports['fivem-appearance']:setPedHeadOverlays(cache.ped, headOverlays);
        local currentAppearance = exports['fivem-appearance']:getPedAppearance(cache.ped);
        TriggerServerEvent('king-skin:server:saveAppearance', currentAppearance);
    end
end);