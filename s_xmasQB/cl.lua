local QBCore = exports['qb-core']:GetCoreObject()
local spawned = false
local spawnedTrees = {}


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
  Wait(10000) --Lets wait until player has really loaded in
  TriggerEvent('s_xmas:CreateTree')
end)


RegisterNetEvent('s_xmas:CreateTree', function()
	local tree = 'prop_xmas_tree_int' --Prop used for trees
	RequestModel(tree)
	while (not HasModelLoaded(tree)) do Wait(10) end
	for k,v in pairs(Config.Trees) do
		trees = CreateObject(tree, v.pos, false, false, false)
		Wait(200)
		if DoesEntityExist(trees) then 
			PlaceObjectOnGroundProperly(trees)
			table.insert(spawnedTrees, trees)
			spawned = true
			DrawStuff()
		end
	end

	if Config.EnableBlips then
		CreateThread(function()
			for k,v in pairs(Config.Trees) do
				blip = AddBlipForCoord(v.pos)
				SetBlipSprite(blip, 587)
				SetBlipColour(blip, 2)
				SetBlipScale(blip, 0.7)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(Config.BlipName) -- set blip's "name"
				EndTextCommandSetBlipName(blip)
			end
		end)
	end
end)

function DrawStuff()
	CreateThread(function()
		local plyped = PlayerPedId()
		Wait(1000)
		while spawned do
			sleep = 1000
			local treeObj, distance = QBCore.Functions.GetClosestObject(GetEntityCoords(PlayerPedId())
			--local closestTree, distance = ESX.Game.GetClosestObject('prop_xmas_tree_int')
			if distance <= 2.3 and treeObj == `prop_xmas_tree_int` then
				sleep = 1
				DrawText3D(GetEntityCoords(closestTree) + vector3(0.0, 0.0, 0.0+1.4), 'Claim your present! [~g~E~s~]', 0.3)
				if IsControlJustReleased(0,38) and not claimed then --Change key to what u want
					claimed = true
					TriggerServerEvent('s_xmas:claim', GetEntityCoords(closestTree), GetEntityCoords(plyped))
					Wait(1000) --Added wait to prevent spamming.
					claimed = false
				end
			end
			Wait(sleep)
		end
	end)
end

AddEventHandler('onResourceStop', function(resource) --self explanatory
	if resource == GetCurrentResourceName() then
		for k,v in pairs(spawnedTrees) do
			DeleteEntity(v)
			spawnedTrees = {}
			spawned = false
		end
	end
end)

function DrawText3D(coords, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())  
    SetTextScale(scale, scale)
    SetTextFont(8)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()  
    AddTextComponentString(text)
    DrawText(_x, _y)  
    local factor = (string.len(text)) / 270
    --DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end