

function Notification(massage, type, time)
    if isESX then
        ESX.ShowNotification(massage, type, time)
    elseif isQBCore then
        QBCore.ShowNotification(massage, type, time)
    end
end 
exports("Notification", Notification)

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




