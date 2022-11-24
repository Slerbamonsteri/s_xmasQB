local ClaimedTrees = {}
local UsersClaim = {}
local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
	for k,v in pairs(Config.Trees) do
		ClaimedTrees[k] = 0
	end
end)

--Prepare your eyes. This is one nasty payout event kekw. Hope you know how to read code
-- Cleaned up with <3 by Baytona :)
--I wouldve used netid's but creating trees locally for players gives out different netids thus i decided to go for tree coords for the checks.
RegisterServerEvent('s_xmas:claim', function(index)
	local Player = QBCore.Functions.GetPlayer(source)
	if ClaimedTrees[index] >= Config.maxGifts then return TriggerClientEvent('QBCore:Notify', src, "This tree is out of gifts :(") end
	if UsersClaim[Player.PlayerData.citizenid][index] then return TriggerClientEvent('QBCore:Notify', src, "You have already claimed your gift!") end

	local rareChance = math.random()

	if rareChance < 0.2 then
		local winnings = Config.RareLootTable[math.random(#Config.RareLootTable)]
		TriggerClientEvent('QBCore:Notify', source, 'You got a rare gift!')
		if winnings.itemtype == "money" then
			Player.Functions.AddMoney('cash', winnings.amount)
			TriggerClientEvent('QBCore:Notify', source, 'Your gift was $'..winnings.amount..'!')
		else
			if Player.Functions.AddItem(winnings.item, winnings.amount) then
				local itemLabel = QBCore.Shared.Items[winnings.item].label
				TriggerClientEvent('QBCore:Notify', source, 'Your gift was a '..itemLabel..'!')
				UsersClaim[Player.PlayerData.citizenid][index] = true
				ClaimedTrees[index] = ClaimedTrees[index] + 1
			end
		end
	else
		local winnings = Config.RareLootTable[math.random(#Config.LootTable)]
		TriggerClientEvent('QBCore:Notify', source, 'Not so lucky, you got a normal gift.')
		if winnings.itemtype == "money" then
			Player.Functions.AddMoney('cash', winnings.amount)
			TriggerClientEvent('QBCore:Notify', source, 'Your gift was $'..winnings.amount..'!')
		else
			if Player.Functions.AddItem(winnings.item, winnings.amount) then
				local itemLabel = QBCore.Shared.Items[winnings.item].label
				TriggerClientEvent('QBCore:Notify', source, 'Your gift was a '..itemLabel..'!')
				UsersClaim[Player.PlayerData.citizenid][index] = true
				ClaimedTrees[index] = ClaimedTrees[index] + 1
			end
		end
	end
end)

--Feel free to use these, I added these for my own debugging but with these you can easily Clear every ped, vehicle and prop known to server.
--For example if cheaters spawn stuff you can use these to remove them. 


--[[
RegisterCommand('clearpeds', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local peds = GetAllPeds()
	if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
		for k,v in pairs(peds) do
			local NetPed1 = NetworkGetEntityFromNetworkId(v)
			if not IsPedAPlayer(NetPed1) then
				DeleteEntity(v)
			end
		end
	end
end)

RegisterCommand('clearvehicles', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local AllVeh = GetAllVehicles()
	if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
		for k,v in pairs(AllVeh) do
			local NetPed1 = NetworkGetEntityFromNetworkId(v)
			DeleteEntity(v)
		end
	end
end)

RegisterCommand('clearprops', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local AllProps = GetAllObjects()
	if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
		for k,v in pairs(AllProps) do
			local NetPed1 = NetworkGetEntityFromNetworkId(v)
			DeleteEntity(v)
		end
	end
end)]]

--Example log, obviously you have to modify it to your liking if you decide to use this.
--xmasLog(121213, 'Present Log', 'Player: '..GetPlayerName(source)..' \nLooted xmas tree and got: '..v.item..' | '..v.amount..'', 'ExampleLog')
--[[
local webhook = 'ENTER WEBHOOK'
function xmasLog(color, name, message, footer)
    local embed = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
            	["text"] = footer,
              },
          }
      }
    PerformHttpRequest(xenons, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end]]