ESX = nil
QBCore = nil
isESX = false
isQBCore = false

local function Framework()
    if Config.Framework == 'esx' then
        ESX = exports["es_extended"]:getSharedObject()
        isESX = true
        return ESX
    end

    if Config.Framework == 'esx-old' then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                if ESX == nil then
                    TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)
                end
            end
        end)
        isESX = true
        return ESX
    end

    if Config.Framework == 'qb-core' then
        QBCore = exports['qb-core']:GetCoreObject()
        isQBCore = true
        return QBCore
    end

    if Config.Framework == 'qb-old' then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                if QBCore == nil then
                    TriggerEvent(Config.SharedObject, function(obj) QBCore = obj end)
                end
            end
        end)
        isQBCore = true
        return QBCore
    end
end
Framework()
exports('Framework', Framework)


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



function ServerCallback(event, callback, ...)
    if isESX then
        ESX.TriggerServerCallback(event, callback, ...)
    elseif isQBCore then
        QBCore.Functions.TriggerCallback(event, callback, ...)
    else
        print('Callback Server Not Found')
    end
end
exports("ServerCallback", ServerCallback)   


function GetPlayerJob()
    if isESX then
        return ESX.GetPlayerData().job
    elseif isQBCore then
        return QBCore.Functions.GetPlayerData().job
    end
end
exports("GetPlayerJob", GetPlayerJob)


function GetPlayerIsValid()
    if isESX then
        return ESX.GetPlayerData() ~= nil
    elseif isQBCore then
        return QBCore.Functions.GetPlayerData() ~= nil
    end
end
exports("GetPlayerIsValid", GetPlayerIsValid)

function GetPlayerData()
    if isESX then
        return ESX.GetPlayerData()
    elseif isQBCore then
        return QBCore.Functions.GetPlayerData()
    end
end
exports("GetPlayerData", GetPlayerData)


function GetPlayerJobName()
    if not GetPlayerIsValid then return false end

    if isESX then
        return ESX.GetPlayerData().job.name
    elseif isQBCore then
        return QBCore.Functions.GetPlayerData().job.name
    end
end
exports("GetPlayerJobName", GetPlayerJobName)


function GetPlayerJobLabel()
    if not GetPlayerIsValid then return false end

    if isESX then
        return ESX.GetPlayerData().job.label
    elseif isQBCore then
        return QBCore.Functions.GetPlayerData().job.label
    end
end
exports("GetPlayerJobLabel", GetPlayerJobLabel)


function GetPlayerJobGrade()
    if not GetPlayerIsValid then return false end
    if isESX then
        return ESX.GetPlayerData().job.grade
    elseif isQBCore then
        return QBCore.Functions.GetPlayerData().job.grade
    end
end
exports("GetPlayerJobGrade", GetPlayerJobGrade)


function GetPlayerJobSalary()
    if not GetPlayerIsValid then return false end
    if isESX then
        return ESX.GetPlayerData().job.grade_salary
    elseif isQBCore then
        return QBCore.Functions.GetPlayerData().job.grade_salary
    end
end
exports("GetPlayerJobSalary", GetPlayerJobSalary)



------------------------------------------------------------------------------------------------

function GetPlayerName()
    if isESX then
        return ESX.GetPlayerData().firstName .. ' ' .. ESX.GetPlayerData().lastName
    elseif isQBCore then
        return QBCore.Functions.GetPlayerData().charinfo.firstname .. ' ' .. QBCore.Functions.GetPlayerData().charinfo.lastname
    end
end
exports("GetPlayerName", GetPlayerName)


------------------------------------------------------------------------------------------------

function Copy(string)
    lib.setClipboard(string)
end
exports("Copy", Copy)

------------------------------------------------------------------------------------------------

function PlayerHaveCharacter()
    if isESX then
        while not ESX.IsPlayerLoaded() do
            Wait(250)
        end
        return true
    elseif isQBCore then
        while not LocalPlayer.state.isLoggedIn do
            Wait(250)
        end
        return true
    end
    return false
end
exports("PlayerHaveCharacter", PlayerHaveCharacter)



















