

function Notification(massage, type, time)
    if isESX then
        ESX.ShowNotification(massage, type, time)
    elseif isQBCore then
        if type == 'info' then 
            type = 'warning'
        end
        QBCore.Functions.Notify(massage, type, time)
    end
end 
exports("Notification", Notification)
exports("Notify", Notification)
 
AddEventHandler('ata_core') 
RegisterNetEvent('ata_core:Notification', function(massage, type, time)
    Notification(massage, type, time)
end)

------------------------------------------------------------------------------------------------


function ShowTextUI(text)
    if Config.TextUI == 'esx' then
        ESX.TextUI(text)
    elseif Config.TextUI == 'qb-core' then
        exports['qb-core']:DrawText(text,'right')
    elseif Config.TextUI == 'okokTextUI' then
        exports['okokTextUI']:Open(text, 'lightgreen', 'right', true)
    end
end
exports("ShowTextUI", ShowTextUI)


------------------------------------------------------------------------------------------------

function CloseTextUI()
    if Config.TextUI == 'esx' then
         ESX.HideUI()
    elseif Config.TextUI == 'qb-core' then
        exports['qb-core']:HideText()
    elseif Config.TextUI == 'okokTextUI' then
        exports['okokTextUI']:Close()
    end
end
exports("CloseTextUI", CloseTextUI)

------------------------------------------------------------------------------------------------

function ProgressBar(...)
    lib.progressBar(...)
end
exports("ProgressBar", ProgressBar)

------------------------------------------------------------------------------------------------

function ProgressBarCircle(...)
    lib.progressCircle(...)
end
exports("ProgressBarCircle", ProgressBarCircle)

------------------------------------------------------------------------------------------------


function RegisterMenu(...)
    lib.registerMenu(...)
end
exports("RegisterMenu", RegisterMenu)


------------------------------------------------------------------------------------------------

function ShowMenu(menuName)
    lib.showMenu(menuName)
end
exports("ShowMenu", ShowMenu) 


------------------------------------------------------------------------------------------------

function SetMenuOptions(menuName, option, index) 
    lib.setMenuOptions(menuName, option, index)
end
exports("SetMenuOptions", SetMenuOptions)

------------------------------------------------------------------------------------------------

function InputDialog(...)
    return lib.inputDialog(...)
end
exports("InputDialog", InputDialog)

------------------------------------------------------------------------------------------------

function RequestMenu(...)
    return lib.alertDialog(...)
end
exports("RequestMenu", RequestMenu)
------------------------------------------------------------------------------------------------

function GetPlayerLoaded()
    if isESX then
        return ESX.IsPlayerLoaded()
    elseif isQBCore then
        return LocalPlayer.state.isLoggedIn
    end
    return false
end
exports("GetPlayerLoaded", GetPlayerLoaded)

------------------------------------------------------------------------------------------------

function SpawnVehicle(model, coords, heading, cb, networked)
    if isESX then
        ESX.Game.SpawnVehicle(model, coords, heading, cb, networked)
    elseif isQBCore then
        QBCore.Functions.SpawnVehicle(model, coords, heading, cb, networked)
    end
end
exports("SpawnVehicle", SpawnVehicle)


------------------------------------------------------------------------------------------------


