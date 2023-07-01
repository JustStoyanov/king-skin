---@type false | number, false | number, false | number
local inClotheshop, inBarber, inTattoo = false, false, false;

-- Misc Functions --

---@param shopType string
local showTextUI = function(shopType)
    lib.showTextUI('[E] '..shopType, {
        style = {
            color = 'rgba(255, 255, 255, 0.8)',
            backgroundColor = 'rgba(51, 112, 165, 0.7)',
            borderRight = '2px solid rgba(25, 56, 82, 0.5)',
            borderBottom = '3px solid rgba(25, 56, 82, 0.5)',
            boxShadow = 'rgba(0, 0, 0, 0.3) 0px 0px 5px',
            borderRadius = '5px'
        }
    });
end

---@param shopType string
---@param data table
ShowFiveMAppearance = function(shopType, data)
    lib.hideTextUI();
    exports['fivem-appearance']:startPlayerCustomization(function(appearance)
        if appearance then
            TriggerServerEvent('king-skin:server:saveAppearance', appearance);
        end
        showTextUI(shopType);
    end, data);
end

---@param data table
---@param blipData table
---@return number
local createBlips = function(data, blipData)
    local blip = klibrary.game.blip.add({
        coords = data.coords,
        sprite = blipData.sprite,
        color = blipData.color,
        scale = blipData.scale,
        label = blipData.label
    });
    return blip;
end

---@param shopSize vector3?
---@param shopType string?
---@param subType string?
---@return vector3
local calculateSize = function(shopSize, shopType, subType)
    local size = vec3(8, 10, 3);
    if shopSize then
        size = shopSize;
    else
        if shopType == 'Clotheshop' then
            if subType == 'Ponsonbys' then
                size = vec3(20, 15, 3);
            elseif subType == 'Suburban' then
                size = vec3(12, 15, 3);
            end
        elseif shopType == 'Barbershop' then
            size = vec3(5, 8, 3);
        elseif shopType == 'Tattoostudio' then
            size = vec3(5, 8, 3);
        end
    end
    return size;
end

-- Zone Functions --

---@param shopType string
local onZoneExit = function(shopType)
    if shopType == 'Clotheshop' then
        inClotheshop = false;
    elseif shopType == 'Barbershop' then
        inBarber = false;
    elseif shopType == 'Tattoostudio' then
        inTattoo = false;
    end lib.hideTextUI();
end

---@param shopType string
---@param shopId number
local onZoneEnter = function(shopType, shopId)
    if shopType == 'Clotheshop' then
        inClotheshop = shopId;
    elseif shopType == 'Barbershop' then
        inBarber = shopId;
    elseif shopType == 'Tattoostudio' then
        inTattoo = shopId;
    end showTextUI(shopType);
end

---@param shopType string
local insideZone = function(shopType)
    if IsControlJustPressed(0, 38) then
        if shopType ~= 'Tattoostudio' then
            lib.showContext(string.format('%s_menu_king_skin', shopType:lower()));
        else
            ShowFiveMAppearance(shopType, {
                ped = false,
                headBlend = false,
                faceFeatures = false,
                headOverlays = false,
                components = false,
                props = false,
                tattoos = true,
                allowExit = true
            });
        end
    end
end

-- Main Thread --

CreateThread(function()
    for shopName, _ in pairs(Config) do
        local shopType = Config[shopName].Type;
        for i = 1, #Config[shopName].Locations do
            local shop = Config[shopName].Locations[i];
            shop.blip = createBlips(shop, Config[shopName].Blip);
            shop.zone = lib.zones.box({
                coords = shop.coords,
                rotation = shop.coords.w,
                size = calculateSize(shop.size, shopType, shop.type),
                debug = shop.debug or false,
                inside = function()
                    insideZone(shopType);
                end,
                onEnter = function()
                    onZoneEnter(shopType, i);
                end,
                onExit = function()
                    onZoneExit(shopType);
                end
            });
        end
    end
end);

-- Exports --

---@return false | number
exports('inClotheshop', function()
    return inClotheshop;
end);

---@return false | number
exports('inBarber', function()
    return inBarber;
end);

---@return false | number
exports('inTattoo', function()
    return inTattoo;
end);