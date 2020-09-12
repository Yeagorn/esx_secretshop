ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_secretshop:buyWeapon')
AddEventHandler('esx_secretshop:buyWeapon',  function(weapon, price)
    
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.UseBlackMoney then
        if xPlayer.getAccount('black_money').money < price then
            TriggerClientEvent('esx:showNotification', _source, (_U('not_enough_money')))
        elseif xPlayer.getAccount('black_money').money >= price then
            if xPlayer.hasWeapon('WEAPON_' .. weapon) then
                TriggerClientEvent('esx:showNotification', _source, (_U('you_already_have')))
            else
                xPlayer.removeAccountMoney("black_money", price)
                xPlayer.addWeapon('WEAPON_' .. weapon, 1)
                TriggerClientEvent('esx:showNotification', _source, (_U('you_have_bought')))
            end
        end
    else 
        if xPlayer.getMoney() < price then
            TriggerClientEvent('esx:showNotification', _source, (_U('not_enough_money')))
        elseif xPlayer.getMoney() >= price then
            if xPlayer.hasWeapon('WEAPON_' .. weapon) then
                TriggerClientEvent('esx:showNotification', _source, (_U('you_already_have')))
            else
                xPlayer.removeMoney(price)
                xPlayer.addWeapon('WEAPON_' .. weapon, 1)
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TriggerClientEvent('esx_secretshop:spawnNPC', -1)
        print("esx_secretshop | Spawned all NPCS")
    else 
        return
    end
end)

-- Testing purposes
--[[RegisterCommand('anim', function(source, args, rawCommand)
    TriggerClientEvent('esx_secretshop:playAnim', source)    
end, false)

RegisterCommand('clearanim', function(source, args, rawCommand)
    TriggerClientEvent('esx_secretshop:stopAnim', source)
end, false)]]