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

function CreateCallback(event, callback)
    if isESX then 
        ESX.RegisterServerCallback(event, callback)
    elseif isQBCore then
        QBCore.Functions.CreateCallback(event, callback)
    else
        return false
    end
end 
exports('CreateCallback', CreateCallback)

------------------------------------------------------------------------------------------------

function Notification (source, message, type, time)
    TriggerClientEvent('ata_core:Notification', source, message, type, time)
end

exports('Notification', Notification)



------------------------------------------------------------------------------------------------

function addMoney(source,amount,type)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == 'cash' then
            xPlayer.addMoney(amount)
        elseif type == 'bank' then
            xPlayer.addAccount('bank', amount)
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
exports('addMoney', addMoney)


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
            xPlayer.removeAccountMoney('cash',amount)
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
end
exports('RemoveMoney', RemoveMoney)


------------------------------------------------------------------------------------------------

function AddItem(source,item,count)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(item, count)
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.AddItem(item, count) -- Fixed QBCore function name
    end
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

function GetPlayerGroup(source)
    if isESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getGroup()
    elseif isQBCore then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        return xPlayer.PlayerData.group
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


function GetOnlineAdmins()
    local admins = {}
    if isESX then
        local players = ESX.GetPlayers()
        for _, playerId in pairs(players) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local group = xPlayer.getGroup()
            for _, adminGroup in pairs(Config.AdminGroup) do
                if group == adminGroup then
                    table.insert(admins, xPlayer.identifier)
                end
            end
        end
    elseif isQBCore then
        local players = QBCore.Functions.GetPlayers()
        for _, playerId in pairs(players) do
            local xPlayer = QBCore.Functions.GetPlayer(tonumber(playerId))
            local group = xPlayer.PlayerData.group
            for _, adminGroup in pairs(Config.AdminGroup) do
                if group == adminGroup then
                    table.insert(admins, xPlayer.PlayerData.citizenid)
                end
            end
        end
    end
    return admins
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









