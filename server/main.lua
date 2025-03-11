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

exports('Framework', Framework)