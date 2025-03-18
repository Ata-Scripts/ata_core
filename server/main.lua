ESX = nil
QBCore = nil
isESX = false
isQBCore = false

local function Framework()
    if Config.Framework == 'esx' then
        if GetResourceState("es_extended") == "started" then
            ESX = exports["es_extended"]:getSharedObject()
            isESX = true
            return ESX
        end
    elseif Config.Framework == 'esx-old' then
        TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)
        isESX = true
        return ESX
    elseif Config.Framework == 'qb-core' then
        if GetResourceState("qb-core") == "started" then
            QBCore = exports['qb-core']:GetCoreObject()
            isQBCore = true
            return QBCore
        end
    elseif Config.Framework == 'qb-old' then
        TriggerEvent(Config.SharedObject, function(obj) QBCore = obj end)
        isQBCore = true
        return QBCore
    end
    return nil
end
Framework()
exports('Framework', Framework)

------------------------------------------------------------------------------------------------

function CreateCallback(event, callback, ...)
    if isESX then 
        ESX.RegisterServerCallback(event, callback, ...)
    elseif isQBCore then
        QBCore.Functions.CreateCallback(event, callback, ...)
    else
        return false
    end
end 
exports('CreateCallback', CreateCallback)



------------------------------------------------------------------------------------------------

function FoundFramework()
    if isESX then
        return 'esx'
    elseif isQBCore then
        return 'qb-core'
    else
        return false
    end
end
exports("FoundFramework", FoundFramework)

------------------------------------------------------------------------------------------------

function Notification (source, message, type, time)
    TriggerClientEvent('ata_core:Notification', source, message, type, time)
end

exports('Notification', Notification)
--- example 
--- exports['ata_core']:Notification(source, "Hello", "error", 10000)



------------------------------------------------------------------------------------------------

function AddMoney(source,amount,type)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == 'cash' then
            xPlayer.addMoney(amount)
        elseif type == 'bank' then
            xPlayer.addAccountMoney('bank', amount)
        end
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if type == 'cash' then
            xPlayer.Functions.AddMoney('cash', amount)
        elseif type == 'bank' then
            xPlayer.Functions.AddMoney('bank', amount)
        end
    end
end
exports('AddMoney', AddMoney)


------------------------------------------------------------------------------------------------

function HaveMoney(source,amount,type)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == 'cash' then
            return xPlayer.getAccount('money').money >= amount
        elseif type == 'bank' then
            return xPlayer.getAccount('bank').money >= amount
        end
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if type == 'cash' then
            return xPlayer.Functions.GetMoney('cash') >= amount
        elseif type == 'bank' then
            return xPlayer.Functions.GetMoney('bank') >= amount
        end
    end
end
exports('HaveMoney', HaveMoney)


------------------------------------------------------------------------------------------------

function RemoveMoney(source,amount,type)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == 'cash' then
            xPlayer.removeMoney(amount) -- Fixed: use removeMoney for cash in ESX
        elseif type == 'bank' then  
            xPlayer.removeAccountMoney('bank', amount)
        end
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if type == 'cash' then
            xPlayer.Functions.RemoveMoney('cash', amount)
        elseif type == 'bank' then
            xPlayer.Functions.RemoveMoney('bank', amount)
        end
    end
    return true
end
exports('RemoveMoney', RemoveMoney)


------------------------------------------------------------------------------------------------

function AddItem(source, item, count)
    if GetResourceState('ox_inventory') == 'started' then
        local canCarry = exports.ox_inventory:CanCarryItem(source, item, count)
        if canCarry then
            exports.ox_inventory:AddItem(source, item, count or 1)
            return true
        else
            return false
        end
    elseif isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.canCarryItem(item, count) then
            xPlayer.addInventoryItem(item, count or 1)
            return true
        else
            Notification(source, 'you dont have space in your inventory', 'error')
            return false
        end
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local canCarry = xPlayer.Functions.AddItem(item, count or 1)
        print(count,item)
        if canCarry then
            return true
        else
            Notification(source, 'you dont have space in your inventory', 'error')
            return false
        end
    end
    return false
end
exports('AddItem', AddItem)

 
------------------------------------------------------------------------------------------------


function RemoveItem(source,item,count)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, count)
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.RemoveItem(item, count) -- Fixed QBCore function name
    end
end
exports('RemoveItem', RemoveItem)


------------------------------------------------------------------------------------------------

function PlayerHasItem(source, item, count)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getInventoryItem(item).count >= count
    elseif isQBCore then
        return QBCore.Functions.HasItem(source, item, count)
    end
end
exports('PlayerHasItem', PlayerHasItem)


-------------------------------------------------------------------------------------------------
function HasCountItem(source,item)

    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getInventoryItem(item).count
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local hasItem = xPlayer.Functions.GetItemByName(item)
        return hasItem and hasItem.amount or 0
    end

end
exports('HasCountItem', HasCountItem)



------------------------------------------------------------------------------------------------


function GetPlayerInventory(source)
    local inv = {}

    if isESX then
            items = ESX.GetPlayerFromId(source).getInventory()
    elseif isQBCore then
            items = QBCore.Functions.GetPlayer(source).PlayerData.items
    end
    
    for k,v in pairs(items) do
        if (v.amount and v.amount > 0) or (v.count and v.count > 0) then
                table.insert(inv, {
                    name  = v.name, 
                    label = v.label,
                    count = (v.amount or v.count),
                    info  = (v.info or v.metadata or false),
                })
        end
    end
    
    return inv
end
exports('GetPlayerInventory', GetPlayerInventory)



------------------------------------------------------------------------------------------------

function GetItemLabel(item)
    if isESX then 
        return ESX.GetItemLabel(item)
    elseif isQBCore then
        return QBCore.Shared.Items[item].label
    else
        return false
    end
end
exports('GetItemLabel', GetItemLabel)

------------------------------------------------------------------------------------------------

function GetPhoneNumber(source)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        local result = exports['ata_core']:FindSQL("users", "phone_number", "identifier = '"..xPlayer.identifier.."'")
        return result
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local result = exports['ata_core']:FindSQL("players", "phone", "citizenid = '"..xPlayer.PlayerData.citizenid.."'")
        return result[1] and result[1].phone
    end
end
exports('GetPhoneNumber', GetPhoneNumber)


------------------------------------------------------------------------------------------------
---


function GetPlayerGroup(source)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getGroup()
    elseif isQBCore then
         local permissions = QBCore.Functions.GetPermission(tonumber(source))
            for group, hasPermission in pairs(permissions) do
            if hasPermission then
                return group
            end
        end
    end
end
exports('GetPlayerGroup', GetPlayerGroup) 

------------------------------------------------------------------------------------------------

function GetPlayerIdentifier(source)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.identifier
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        return xPlayer.PlayerData.citizenid
    end
end
exports('GetPlayerIdentifier', GetPlayerIdentifier)


------------------------------------------------------------------------------------------------

function GetAllPlayers()
    local players = {}
    if isESX then
        players = ESX.GetPlayers()
    elseif isQBCore then
        players = QBCore.Functions.GetPlayers()
    end
    return players
end
exports('GetAllPlayers', GetAllPlayers)
-----


function GetOnlineAdmins()
    local adminIds = {}
    if isESX then
        local players = ESX.GetPlayers()
        for _, playerId in pairs(players) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                local group = xPlayer.getGroup()
                for _, adminGroup in pairs(Config.AdminGroup) do
                    if group == adminGroup then
                        table.insert(adminIds, playerId)
                        break
                    end
                end
            end
        end 
    elseif isQBCore then
        local players = QBCore.Functions.GetPlayers()
        for _, playerId in pairs(players) do
            local xPlayer = QBCore.Functions.GetPlayer(tonumber(playerId))
            if xPlayer then
                local permission = QBCore.Functions.GetPermission(tonumber(playerId))
                if permission then
                    for _, adminGroup in pairs(Config.AdminGroup) do
                        if permission[adminGroup] then
                            table.insert(adminIds, tonumber(playerId))
                            break
                        end
                    end
                end
            end
        end
    end
    
    -- Example of return value:
    -- adminIds = {1, 5, 10} (server IDs of admin players)
    return adminIds
end
exports('GetOnlineAdmins', GetOnlineAdmins)


------------------------------------------------------------------------------------------------


function GetPlayerFromIdentity(identity)
    if isESX then
        return ESX.GetPlayerFromIdentifier(identity)
    elseif isQBCore then
        return QBCore.Functions.GetPlayerFromId(identity)
    end
end
exports('GetPlayerFromIdentity', GetPlayerFromIdentity)

------------------------------------------------------------------------------------------------


function GetPlayerIDfromIdentity(identity)
    if isESX then
        local players = ESX.GetPlayers()
        for _, playerId in pairs(players) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.identifier == identity then
                return playerId
            end
        end
    elseif isQBCore then
        local players = QBCore.Functions.GetPlayers()
        for _, playerId in pairs(players) do
            local xPlayer = QBCore.Functions.GetPlayer(tonumber(playerId))
            if xPlayer and xPlayer.PlayerData.citizenid == identity then
                return tonumber(playerId)
            end
        end
    end
    return false
end
exports('GetPlayerIDfromIdentity', GetPlayerIDfromIdentity)



------------------------------------------------------------------------------------------------

function GetPlayerJobLabel(job)
    if isESX then
        return ESX.GetJobs()[job].label or 'unknown'
    elseif isQBCore then
        return QBCore.Shared.Jobs[job].label or 'unknown'
    end
end
exports('GetPlayerJobLabel', GetPlayerJobLabel)


------------------------------------------------------------------------------------------------


function GetPlayerJob(source)
    if isESX then
        return ESX.GetPlayerFromId(source).job.name
    elseif isQBCore then
        return QBCore.Functions.GetPlayer(source).PlayerData.job
    end
end
exports('GetPlayerJob', GetPlayerJob)
 
------------------------------------------------------------------------------------------------

function SendNotificationToAdmins(msg)
    local admins = GetOnlineAdmins()
    for _, admin in pairs(admins) do
        local xPlayer = GetPlayerIDfromIdentity(admin)
        if xPlayer then
            TriggerClientEvent('ata_core:Notification', xPlayer, msg, 'error', 10000)
        end
    end
end
exports('SendNotificationToAdmins', SendNotificationToAdmins)


------------------------------------------------------------------------------------------------


function PlayerHasGroup(source,group)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getGroup() == group
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        return xPlayer.PlayerData.group == group
    end
end
exports('PlayerHasGroup', PlayerHasGroup)


------------------------------------------------------------------------------------------------

function GetPlayerSkin(source)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getSkin()
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        return xPlayer.PlayerData.skin
    end
end


-- ESX Events
AddEventHandler('esx:playerLoaded', function(source, xPlayer, isNew)
    local src = source
    if xPlayer then
        TriggerClientEvent('ata_core:NewPlayerCreatedCharacter', src)
    end
end)

-- QBCore Events 
AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    local src = Player.PlayerData.source
    TriggerClientEvent('ata_core:NewPlayerCreatedCharacter', src)
end)




local function VersionCheck(resource)
    local url = 'https://raw.githubusercontent.com/Ata-Scripts/ata_version/main/versions.json'
    local current = GetResourceMetadata(resource, 'version', 0)
    
    if not current then
        Debug('[^1ERROR^0] Could not get version for ' .. resource .. '. Make sure version is set in fxmanifest.lua')
        return
    end

    PerformHttpRequest(url, function(err, response, headers)
        if err == 200 then
            local success, data = pcall(json.decode, response)
            if success and data then
                -- Convert resource name to lowercase for case-insensitive comparison
                local resourceLower = string.lower(resource)
                local found = false
                
                -- Check for the resource in the version list (case-insensitive)
                for k, v in pairs(data) do
                    if string.lower(k) == resourceLower then
                        found = true
                        local latest = v
                        if latest ~= current then
                            print('\n')
                            print('^3[' .. resource .. ']  UPDATE AVAILABLE^0')
                            print('^3[' .. resource .. '] ^1 You are using version: ' .. current .. '^0')
                            print('^3[' .. resource .. '] ^2 New version available: ' .. latest .. '^0')
                            print('\n')
                        else
                            Debug('^2[' .. resource .. '] You are using the latest version: ' .. current .. '^0')
                        end
                        break
                    end
                end
                
                if not found then
                    Debug('^3[' .. resource .. '] Resource not found in version database^0')
                end
            else
                Debug('^1[' .. resource .. '] Failed to parse version data^0')
            end
        else
            Debug('^1[' .. resource .. '] Failed to check for updates: ' .. (err or 'unknown error') .. '^0')
        end
    end, 'GET', '', { ["Content-Type"] = 'application/json' })
end

exports('VersionCheck', VersionCheck)

CreateThread(function()
    Wait(10000) -- Wait for resource to fully start
    VersionCheck('ata_core')
end)


