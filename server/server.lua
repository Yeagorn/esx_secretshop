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
        TriggerClientEvent('bsrp:spawnNPC', -1)
        print("DT WEAPONSHOP | Spawned all NPCS")
    else 
        return
    end
end)

RegisterCommand('anim', function(source, args, rawCommand)
    TriggerClientEvent('bsrp:playAnim', source)    
end, false)

RegisterCommand('clearanim', function(source, args, rawCommand)
    TriggerClientEvent('bsrp:stopAnim', source)
end, false)