ESX = nil
local missionPed
local generalPed
local isInMission = false
local SpawnedPeds = false
local PlayingAnim = false

local blips = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx_secretshop:playAnim')
AddEventHandler('esx_secretshop:playAnim', function(source)
    RequestAnimDict("random@shop_gunstore")
    while (not HasAnimDictLoaded("random@shop_gunstore")) do 
        Citizen.Wait(0) 
    end
    local pPed = GetPlayerPed(source)
    TaskPlayAnim(pPed, "random@shop_gunstore", "_idle_b", 1.0, -1.0, -1, 4000, 1, true, true, true)
end)

RegisterNetEvent('esx_secretshop:stopAnim')
AddEventHandler('esx_secretshop:stopAnim', function(source)
    local pPed = GetPlayerPed(source)
    ClearPedTasksImmediately(pPed)
end)

RegisterNetEvent('esx_secretshop:spawnNPC')
AddEventHandler('esx_secretshop:spawnNPC', function()
    SpawnNPC()
    SpawnMissionNPC()
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if SpawnedPeds == false then
            SpawnNPC()
            SpawnMissionNPC()
            SpawnedPeds = true
        end

    end
end)

function SpawnNPC()
    for k,v in ipairs(Config.NPC) do
        RequestModel(GetHashKey("a_m_y_salton_01"))
        while not HasModelLoaded(GetHashKey("a_m_y_salton_01")) do
            Wait(1)
        end
        generalPed = CreatePed(PED_TYPE_GANG_KOREAN, "a_m_y_salton_01", v.x, v.y, v.z, v.h, false, false)
        SetPedFleeAttributes(generalPed, 0, 0)
        TaskPlayAnim(generalPed, "random@shop_gunstore", "_idle_b", 1.0, -1.0, -1, 0, 1, true, true, true)
        FreezeEntityPosition(generalPed, true)
	    SetEntityInvincible(generalPed, true)
	    SetBlockingOfNonTemporaryEvents(generalPed, true)
    end
end

function SpawnMissionNPC()
    for k,v in ipairs(Config.MissionNPC) do
        RequestModel(GetHashKey("a_m_y_salton_01"))
        while not HasModelLoaded(GetHashKey("a_m_y_salton_01")) do
            Wait(1)
        end
        missionPed = CreatePed(PED_TYPE_GANG_KOREAN, "a_m_y_salton_01", v.x, v.y, v.z, v.h, false, false)
        SetPedFleeAttributes(missionPed, 0, 0)
        TaskPlayAnim(missionPed, "random@shop_gunstore", "_idle_b", 1.0, -1.0, -1, 0, 1, true, true, true)
        FreezeEntityPosition(missionPed, true)
	    SetEntityInvincible(missionPed, true)
	    SetBlockingOfNonTemporaryEvents(missionPed, true)
    end
end

function IsNearNPC()

    RequestAnimDict("random@shop_gunstore")
        while (not HasAnimDictLoaded("random@shop_gunstore")) do 
            Citizen.Wait(0) 
        end

    local player = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(player, 0)
    for _, item in pairs(Config.NPC) do
        local ped = GetClosestPed(item.x, item.y, item.z, 20.05, 1, 0, 0, 0, -1)
        local distance = GetDistanceBetweenCoords(item.x, item.y, item.z, playerCoords["x"], playerCoords["y"], playerCoords["z"], true)
        if (distance < 3) then
            TaskPlayAnim(ped, "random@shop_gunstore", "_greeting", 1.0, -1.0, 4000, true, true, true)
            return true
        else
            TaskPlayAnim(ped, "random@shop_gunstore", "_idle_b", 1.0, -1.0, 0, true, true, true)
            return false
        end
    end
end

function IsNearMissionNPC()
    
    RequestAnimDict("random@shop_gunstore")
    while (not HasAnimDictLoaded("random@shop_gunstore")) do 
        Citizen.Wait(0) 
    end

    local player = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(player, 0)

    for _, item in pairs(Config.MissionNPC) do
        local ped = GetClosestPed(item.x, item.y, item.z, 20.05, 1, 0, 0, 0, -1)
        local distance = GetDistanceBetweenCoords(item.x, item.y, item.z, playerCoords["x"], playerCoords["y"], playerCoords["z"], true)
        if (distance < 3) then
            TaskPlayAnim(ped, "random@shop_gunstore", "_greeting", 1.0, -1.0, 4000, true, true, true)
            return true
        else
            TaskPlayAnim(ped, "random@shop_gunstore", "_idle_b", 1.0, -1.0, 0, true, true, true)
            return false
        end
    end
end

function OpenMissionMenu()
    ESX.UI.Menu.CloseAll()

    local elements = {
        { label = _U("weapon_mission"), value = "weapons" },
        { label = _U("cancel_missions"), value = "cancel" }
    }

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'missions', {
            title = _U('missions'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == "weapons" then
                ESX.ShowNotification(_U("showed_the_way"))
                for _, item in pairs(Config.NPC) do
                blip = AddBlipForCoord(item.x, item.y, item.z)
                SetBlipRoute(blip, true)
                SetBlipRouteColour(blip, 5)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(_U('mission_blip'))
                EndTextCommandSetBlipName(blip)
                table.insert(blips, blip)
                isInMission = true
                TriggerServerEvent("esx_secretshop:notifyPolice")
                end
            elseif data.current.value == "cancel" then
                ESX.ShowNotification(_U('mission_canceled'))
                ClearAllBlipRoutes()
                RemoveBlip(blip)
                isInMission = false
                TriggerServerEvent("esx_secretshop:stopPolice")
            end
        end, function(data, menu)
            menu.close()
        end
    )
end

function OpenWeaponMenu()
    ESX.UI.Menu.CloseAll()

    local elements = {}

    for i=1, #Config.Items, 1 do
        local item = Config.Items[i]  
        table.insert(elements, {
            label     = item.label .. ' - <span style="color:green;">$' .. item.price .. ' </span>',
            price     = item.price,
            value     = item.name
        })
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'weaponmenu', {
            title = _U('weaponmenu'),
            align = 'bottom-right',
            elements = elements
        }, function(data, menu)
            TriggerServerEvent('esx_secretshop:buyWeapon', data.current.value, data.current.price)
        end, function(data, menu)
            menu.close()
        end
    )
end

function removeBlip()
    for i, blip in pairs(blips) do
        RemoveBlip(blip)
    end
    blips = {}
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (IsNearMissionNPC()) then
            ESX.ShowHelpNotification(_U('talk_with_mission'))
            if IsControlJustPressed(0, 38) then
                OpenMissionMenu()
                TaskPlayAnim(ped, "random@shop_gunstore", "_greeting", 1.0, -1.0, 4000, true, true, true)
                Citizen.Wait(4000)
            end
        else
            TaskPlayAnim(ped,"random@shop_gunstore","_idle_b", 1.0, -1.0, -1, 0, 1, true, true, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (IsNearNPC()) then
            ClearAllBlipRoutes()
            removeBlip()
            ESX.ShowHelpNotification(_U('talk_with_gang'))
            if IsControlJustPressed(0, 38) then
                OpenWeaponMenu()
            end
        end
    end
end)