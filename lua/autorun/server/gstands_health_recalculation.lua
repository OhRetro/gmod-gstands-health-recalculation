local normalMaxHealth = 100
local gstandsMaxHealth = 1500

if not file.Exists("gstands_health_recalculation.txt", "DATA") then
    file.Write("gstands_health_recalculation.txt", "1")
end

local function setMaxHP(player, amount)
    player:SetMaxHealth(amount)
    player:SetHealth(amount)
end

local function recalculateHP(player, newMaxHealth)
    local hpPercent = math.Round(player:Health() / player:GetMaxHealth(), 2)
    return newMaxHealth * hpPercent
end

concommand.Add("gstands_health_recalculation_enable", function(player, _, args)
    local currentValue = tonumber(file.Read("gstands_health_recalculation.txt", "DATA"))
    local newValue

    if currentValue == 1 then
        newValue = 0
    else
        newValue = 1
    end

    file.Write("gstands_health_recalculation.txt", newValue)
end)

hook.Add("PlayerSwitchWeapon", "CheckWeaponPrefix", function(player, oldWeapon, newWeapon)
    if tonumber(file.Read("gstands_health_recalculation.txt", "DATA")) != 1 then
        return
    end

    if string.StartWith(oldWeapon:GetClass(), "gstands_") then
        local recalculatedHP = recalculateHP(player, normalMaxHealth)
        setMaxHP(player, normalMaxHealth)
        player:SetHealth(recalculatedHP)
    elseif string.StartWith(newWeapon:GetClass(), "gstands_") then
        local recalculatedHP = recalculateHP(player, gstandsMaxHealth)
        setMaxHP(player, gstandsMaxHealth)
        player:SetHealth(recalculatedHP)
    end
end)
