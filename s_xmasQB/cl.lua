local QBCore = exports['qb-core']:GetCoreObject()
local spawned = false
local spawnedTrees = {}
local claimed = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	createTrees()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	deleteTrees()
end)

local function DrawStuff()
	if not spawned then return end
	while spawned do
		local sleep = 500
		for k,v in pairs(Config.Trees) do
			local ped = PlayerPedId()
			local dist = #(GetEntityCoords(ped) - GetEntityCoords(v.tree))
			if dist < 3 then
				sleep = 0
				DrawText3D(GetEntityCoords(v.tree) + vector3(0.0, 0.0, 0.0+1.4), 'Claim your present! [~g~E~s~]', 0.3)
				if IsControlJustReleased(0,38) and not claimed then --Change key to what u want
					claimed = true
					TriggerServerEvent('s_xmas:claim', k)
					Wait(1000)
					claimed = false
				end
			end
		end
		Wait(sleep)
	end
end

function deleteTrees()
	if not spawned then return end
	for k,v in pairs(Config.Trees) do
		if v.tree then
			DeleteEntity(v.tree)
		end
	end
	spawned = false
end

function createTrees()
	if spawned then return end
	local tree = 'prop_xmas_tree_int' --Prop used for trees
	RequestModel(tree)

	for k,v in pairs(Config.Trees) do
		Config.Trees[k].tree = CreateObject(tree, v.pos, false, false, false)
		Wait(200)
		if DoesEntityExist(trees) then 
			PlaceObjectOnGroundProperly(trees)
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

	spawned = true
end

AddEventHandler('onResourceStop', function(resource) --self explanatory
	if resource == GetCurrentResourceName() then
		for k,v in pairs(Config.Trees) do
			if v.tree then
				DeleteEntity(v)
				spawned = false
			end
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
end