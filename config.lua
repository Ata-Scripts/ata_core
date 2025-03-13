
Config = {}


Config.Framework = 'esx' -- esx , esx-old , qb-core , qb-old

Config.SharedObject = 'QBCore:GetCoreObject' -- esx:getSharedObject , QBCore:GetCoreObject --- !! Just for old versions !!

Config.TextUI = 'esx' -- esx , qb-core , okokTextUI

Config.Key = 38 -- 38 is E key

Config.Target = 'ox_target' -- ox_target , qb-target

Config.SQL = 'oxmysql' -- oxmysql , ghmattimysql , mysql-async

Config.Debug = true ---- true or false (for debug)


Config.AdminGroup = {
    'admin',
    'god'
}


function MoneyType(Money)
    local formatted = tostring(Money)
    formatted = formatted:reverse():gsub("(%d%d%d)", "%1,")
    formatted = formatted:reverse()
    if formatted:sub(1, 1) == "," then
        formatted = formatted:sub(2)
    end
    return "$" .. formatted
end

exports("MoneyType", MoneyType)


function Debug(text)
    if Config.Debug then
        print(text)
    end
end
