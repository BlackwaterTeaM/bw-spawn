local QBCore = exports['qb-core']:GetCoreObject()
local spwandata = Config.Spawns
local playerNew = false
local function spawnNow(spawnData)
    local coords
    if spawnData == "lastLocation" then
        QBCore.Functions.GetPlayerData(function(PlayerData)
            local currentLocation = {
                x = PlayerData.position.x,
                y = PlayerData.position.y,
                z = PlayerData.position.z,
            }
            coords = vector3(currentLocation.x, currentLocation.y, currentLocation.z)
        end)
    else
        coords = Config.Spawns[spawnData].vector3Value
    end
    local saveData = true
    if saveData then
        playerDefalut = GetEntityModel(PlayerPedId())
        PlayerData = GetHashKey(playerDefalut)
        saveData = false
    end
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    StartPlayerTeleport(PlayerId(), coords.x, coords.y, coords.z, 0.0, true, true, true)
    while IsPlayerTeleportActive() do
        Citizen.Wait(0)
    end
    SetEntityVisible(PlayerPedId(), true)

    DoScreenFadeIn(500)
    if playerNew then
        TriggerEvent('qb-clothes:client:CreateFirstCharacter')
    end
    Citizen.Wait(100)
end
local function uiShow()
    SendNUIMessage({
        type = "show",
        data = spwandata,
        playerNew = playerNew
    })
    SetNuiFocus(true, true)
    local playerDefalut = GetEntityModel(PlayerPedId())
    PlayerData = GetHashKey(playerDefalut)
    SetPlayerModel(PlayerPedId(), PlayerData)
end
local findNewPlayer = false
function HandleKeyPress()
    while true do
        Citizen.Wait(0)
        if IsControlPressed(0, 224) and IsControlJustPressed(0, 302) then -- 29 is the "Ctrl" key, and 47 is the "S" key
            uiShow()
        end
        if findNewPlayer then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                local playerData = json.encode(PlayerData.id)
                if playerData == "null" then
                    playerNew = true
                    findNewPlayer = false
                else
                    playerNew = false
                    findNewPlayer = false
                end
            end)
        end
    end
end

RegisterNetEvent('qb-clothing:client:onMenuClose', function()
    local PlayerData = GetEntityCoords(PlayerPedId())
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.x, PlayerData.y, PlayerData.z + 800.0, 85.00,
        0.00,
        0.00, 100.00, false, 0)
    SetCamParams(cam, PlayerData.x, PlayerData.y, PlayerData.z, 0.00, 0.00, 0.00, -120.00, -800, 0,
        0, .3)
    Wait(30)
    RenderScriptCams(false, true, 30, true, true)
    SetCamActive(cam, false)
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
end)
RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)
RegisterNUICallback('spawnNow', function(data, cb)
    local spawndata = data.spawn
    spawnNow(spawndata)
    SetNuiFocus(false, false)
    cb('ok')
end)
RegisterNetEvent('qb-spawn:client:setupSpawns', function(cData, new, apps)
    data = cData
    if new then
        uiShow()
    elseif not new then
        playerNew = false
        uiShow()
    end
    findNewPlayer = true
end)
Citizen.CreateThread(HandleKeyPress)
