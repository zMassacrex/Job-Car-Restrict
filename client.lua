if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('qbx_core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function ShowNotification(title, message, type)
    if Config.NotificationSystem == 'auto' then
        if GetResourceState('es_extended') == 'started' then 
            ESX.ShowNotification(message)
        elseif GetResourceState('qb-core') == 'started' then
            QBCore.Functions.Notify(message, type, 5000)
        elseif GetResourceState('qbx_core') == 'started' then
            QBCore.Functions.Notify(message, type, 5000)
        end

    elseif Config.NotificationSystem == 'okokNotify' then
        TriggerEvent('okokNotify:Alert', title, message, 5000, type)
    elseif Config.NotificationSystem == 'ESX' then
        ESX.ShowNotification(message)
    elseif Config.NotificationSystem == 'QBCore' or 'QBox' then 
        QBCore.Functions.Notify(message, type, 5000)
    elseif Config.NotificationSystem == 'ox_lib' then
        lib.notify({
            title = title,
            description = message,
            type = type
        })
    end
end

local function IsVehicleAllowedForJob(vehicle, job)
    local model = GetEntityModel(vehicle)
    local allowedVehicles = Config.JobVehicles[job]
    if allowedVehicles then
        for _, vehicleName in ipairs(allowedVehicles) do
            if model == GetHashKey(vehicleName) then
                return true
            end
        end
    end
    return false
end

local function TeleportToSideOfVehicle(ped, vehicle)
    TaskLeaveVehicle(ped, vehicle, 1)
end


lib.onCache('vehicle', function(vehicle)
    if vehicle and GetPedInVehicleSeat(vehicle, -1) == cache.ped then
        if GetPlayerData().job then
            if not IsVehicleAllowedForJob(vehicle, GetPlayerData().job.name) then
                TaskLeaveVehicle(cache.ped, vehicle, 0)
                Wait(500)
                TeleportToSideOfVehicle(cache.ped, vehicle)
                ShowNotification(Config.Translations.error_title, Config.Translations.no_permission, 'error')
            end
        end
    end
end)

function GetPlayerData()
    if GetResourceState('es_extended') == 'started' then 
        return ESX.GetPlayerData()
    elseif GetResourceState('qb-core') == 'started' then
        return QBCore.Functions.GetPlayerData()
    elseif GetResourceState('qbx_core') == 'started' then
        return QBCore.Functions.GetPlayerData()
    end
end