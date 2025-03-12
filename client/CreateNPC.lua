

local npcList = {}



local function playAnimation(npc, animType)
    local animDict = "missheistdockssetup1clipboard@base"
    local animName = "base"

    if animType == "clipboard" then
        animDict = "missheistdockssetup1clipboard@base"
        animName = "base"
    elseif animType == "idle" then
        animDict = "amb@world_human_stand_guard@male@idle_a" 
        animName = "idle_a"
    elseif animType == "notepad" then
        animDict = "amb@medic@standing@timeofdeath@base"
        animName = "base"
    elseif animType == "tablet" then
        animDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
        animName = "base"
    elseif animType == "gesture" then
        animDict = "gestures@m@standing@casual"
        animName = "gesture_hello"
    elseif animType == "coffee" then
        animDict = "amb@world_human_aa_coffee@base"
        animName = "base"
    elseif animType == "smoke" then
        animDict = "amb@world_human_smoking@male@male_a@base"
        animName = "base"
    elseif animType == "phone" then
        animDict = "cellphone@"
        animName = "cellphone_text_read_base"
    elseif animType == "lean" then
        animDict = "amb@world_human_leaning@male@wall@back@foot_up@base"
        animName = "base"
    elseif animType == "sit" then
        animDict = "amb@world_human_seat_steps@male@idle_a"
        animName = "idle_a"
    elseif animType == "clean" then
        animDict = "amb@world_human_maid_clean@base"
        animName = "base"
    elseif animType == "guard" then
        animDict = "amb@world_human_guard_patrol@male@base"
        animName = "base"
    elseif animType == "strip_club" then
        animDict = "mini@strip_club@idles@bouncer@base"
        animName = "base"
    else
        print('Animation Not Found')
        return
    end

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end

    TaskPlayAnim(npc, animDict, animName, 8.0, -8.0, -1, 1, 0, true, true, true)
    RemoveAnimDict(animDict)
end

-- Function to create NPC with interaction
function CreateNPCWithKey(npcModel, coords, heading, text, eventName, eventData, eventType, animation, target)

    local IsTarget = target or false
    local resourceName = GetInvokingResource() -- Get the script name that called this function
    if not resourceName then
        print("^1[ata_core] ERROR: Unable to determine resource name!^0")
        return 
    end

    local model = GetHashKey(npcModel) -- NPC model

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
 
    local npc = CreatePed(4, model, coords, heading, false, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)

    -- Store NPC with the script name that created it
    npcList[#npcList + 1] = { npc = npc, coords = coords, eventName = eventName, eventData = eventData ,  eventType = eventType, animation = animation, script = resourceName }

    -- Initial animation play
    if animation then
        playAnimation(npc, animation)
    end

    -- Start thread for interaction
    if not IsTarget then
        CreateThread(function()
            local ShowingTextUI = false
            while DoesEntityExist(npc) do
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local npcCoords = vector3(coords.x, coords.y, coords.z)
                local dist = #(playerCoords - npcCoords)
                local sleep = true
                if dist <= 2.5 then
                    sleep = false 
                    if not ShowingTextUI then
                        ShowTextUI(text)
                        ShowingTextUI = true
                    end
                    if IsControlJustReleased(0, 38) then
                        if eventType == "server" then
                            if eventData then
                                TriggerServerEvent(eventName, eventData)
                            else
                                TriggerServerEvent(eventName)
                            end
                        else
                            if eventData then
                                TriggerEvent(eventName, eventData)
                            else
                                TriggerEvent(eventName)
                            end
                        end
                    end
                else
                    if ShowingTextUI then
                        sleep = true
                        CloseTextUI()
                        ShowingTextUI = false
                    end
                end
                if sleep then
                    Wait(1000)
                else
                    Wait(0)
                end
            end
        end)
    else
        if Config.Target == 'ox_target' then
            exports.ox_target:addLocalEntity(npc, {
                {
                    name = 'npc_interact',
                    label = text,
                    icon = 'fa-solid fa-user',
                    onSelect = function()
                        if eventType == "server" then
                            if eventData then
                                TriggerServerEvent(eventName, eventData)
                            else
                                TriggerServerEvent(eventName)
                            end
                        else
                            if eventData then
                                TriggerEvent(eventName, eventData)
                            else
                                TriggerEvent(eventName)
                            end
                        end
                    end,
                    distance = 2.0
                }
            })
        elseif Config.Target == 'qb-target' then
            exports['qb-target']:AddTargetEntity(npc, {
                options = {
                    {
                        num = 1,
                        type = eventType,
                        event = eventName,
                        icon = 'fa-solid fa-user',
                        label = text,
                        distance = 2.0,
                        action = function()
                            if eventType == "server" then
                                if eventData then 
                                    TriggerServerEvent(eventName, eventData)
                                else
                                    TriggerServerEvent(eventName)
                                end
                            else
                                if eventData then
                                    TriggerEvent(eventName, eventData)
                                else
                                    TriggerEvent(eventName)
                                end
                            end
                        end
                    }
                }
            })
        end
    end

    SetModelAsNoLongerNeeded(model)
    return npc
end
exports("CreateNPCWithKey", CreateNPCWithKey)


-- Cleanup NPCs when a script using this export is restarted
AddEventHandler("onResourceStop", function(resourceName)
    for i = #npcList, 1, -1 do
        local npcData = npcList[i]
        if npcData.script == resourceName then
            if DoesEntityExist(npcData.npc) then
                DeleteEntity(npcData.npc)
                print('NPC Deleted')
                table.remove(npcList, i) -- Remove from table
            end
        end
    end
    if resourceName == GetCurrentResourceName() then
        for i = #npcList, 1, -1 do
            local npcData = npcList[i]
            if DoesEntityExist(npcData.npc) then
                DeleteEntity(npcData.npc)
            end
        end
    end
end)
